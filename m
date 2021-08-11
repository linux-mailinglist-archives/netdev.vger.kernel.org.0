Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106243E8914
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 06:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhHKEHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 00:07:35 -0400
Received: from smtprelay0095.hostedemail.com ([216.40.44.95]:34382 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229554AbhHKEHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 00:07:34 -0400
Received: from omf11.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id B2245181CC1B7;
        Wed, 11 Aug 2021 04:07:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf11.hostedemail.com (Postfix) with ESMTPA id B927C20A296;
        Wed, 11 Aug 2021 04:07:08 +0000 (UTC)
Message-ID: <c8b69905c995ab887633ef11862705ee66c60aad.camel@perches.com>
Subject: Re: [PATCH] netlink: NL_SET_ERR_MSG - remove local static array
From:   Joe Perches <joe@perches.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Tue, 10 Aug 2021 21:07:07 -0700
In-Reply-To: <20210810133058.0c7f0736@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1f99c69f4e640accaf7459065e6625e73ec0f8d4.camel@perches.com>
         <20210810133058.0c7f0736@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.82
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: B927C20A296
X-Stat-Signature: erbj8ue88trry6nswhxoahbaokjr61fi
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+6DgYlB/FaT7vkiYsQX+R3g2pF1EQooxU=
X-HE-Tag: 1628654828-659544
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-08-10 at 13:30 -0700, Jakub Kicinski wrote:
> On Mon, 09 Aug 2021 10:04:00 -0700 Joe Perches wrote:
> > The want was to have some separate object section for netlink messages
> > so all netlink messages could be specifically listed by some tool but
> > the effect is duplicating static const char arrays in the object code.
> > 
> > It seems unused presently so change the macro to avoid the local static
> > declarations until such time as these actually are wanted and used.
> > 
> > This reduces object size ~8KB in an x86-64 defconfig without modules.
[]
> > diff --git a/include/linux/netlink.h b/include/linux/netlink.h
[]
> > @@ -89,13 +89,12 @@ struct netlink_ext_ack {
> >   * to the lack of an output buffer.)
> >   */
> >  #define NL_SET_ERR_MSG(extack, msg) do {		\
> > -	static const char __msg[] = msg;		\
> >  	struct netlink_ext_ack *__extack = (extack);	\
> >  							\
> > -	do_trace_netlink_extack(__msg);			\
> > +	do_trace_netlink_extack(msg);			\
> >  							\
> >  	if (__extack)					\
> > -		__extack->_msg = __msg;			\
> > +		__extack->_msg = msg;			\
> >  } while (0)
> 
> But you've made us evaluate msg multiple times now.
> Given extack is carefully evaluated only once this stands out.

msg is always a const char array so no evaluation is done.
It's just a pointer.

In fact, this could either become a static inline or a
simple function call to reduce object size even further.

For instance:

$ size vmlinux.o.nl_func.*
   text	   data	    bss	    dec	    hex	filename
19974564	3457991	 741312	24173867	170dd2b	vmlinux.o.nl_func.new
19992097	3457967	 741312	24191376	1712190	vmlinux.o.nl_func.old

---
 include/linux/netlink.h  | 29 ++++++++++-------------------
 net/netlink/af_netlink.c | 13 +++++++++++++
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 61b1c7fcc401e..fe80c2704cc23 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -82,21 +82,16 @@ struct netlink_ext_ack {
 	u8 cookie_len;
 };
 
+void netlink_set_err_msg(struct netlink_ext_ack *extack, const char *msg);
 /* Always use this macro, this allows later putting the
  * message into a separate section or such for things
  * like translation or listing all possible messages.
  * Currently string formatting is not supported (due
  * to the lack of an output buffer.)
  */
-#define NL_SET_ERR_MSG(extack, msg) do {		\
-	static const char __msg[] = msg;		\
-	struct netlink_ext_ack *__extack = (extack);	\
-							\
-	do_trace_netlink_extack(__msg);			\
-							\
-	if (__extack)					\
-		__extack->_msg = __msg;			\
-} while (0)
+
+#define NL_SET_ERR_MSG(extack, msg)		\
+	netlink_set_err_msg(extack, msg)
 
 #define NL_SET_ERR_MSG_MOD(extack, msg)			\
 	NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " msg)
@@ -110,16 +105,12 @@ struct netlink_ext_ack {
 
 #define NL_SET_BAD_ATTR(extack, attr) NL_SET_BAD_ATTR_POLICY(extack, attr, NULL)
 
-#define NL_SET_ERR_MSG_ATTR_POL(extack, attr, pol, msg) do {	\
-	static const char __msg[] = msg;			\
-	struct netlink_ext_ack *__extack = (extack);		\
-								\
-	do_trace_netlink_extack(__msg);				\
-								\
-	if (__extack) {						\
-		__extack->_msg = __msg;				\
-		__extack->bad_attr = (attr);			\
-		__extack->policy = (pol);			\
+#define NL_SET_ERR_MSG_ATTR_POL(extack, attr, pol, msg)		\
+do {								\
+	netlink_set_err_msg(extack, msg);			\
+	if (extack) {						\
+		extack->bad_attr = (attr);			\
+		extack->policy = (pol);				\
 	}							\
 } while (0)
 
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 24b7cf447bc55..b6d035f0d343b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2561,6 +2561,19 @@ int nlmsg_notify(struct sock *sk, struct sk_buff *skb, u32 portid,
 }
 EXPORT_SYMBOL(nlmsg_notify);
 
+/**
+ * nl_set_err_msg - 
+ */
+
+void netlink_set_err_msg(struct netlink_ext_ack *extack, const char *msg)
+{
+	do_trace_netlink_extack(msg);
+
+	if (extack)
+		extack->_msg = msg;
+}
+EXPORT_SYMBOL(netlink_set_err_msg);
+
 #ifdef CONFIG_PROC_FS
 struct nl_seq_iter {
 	struct seq_net_private p;


