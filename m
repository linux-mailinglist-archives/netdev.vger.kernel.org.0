Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78EAC8DF77
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfHNU40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:56:26 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:41555 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729547AbfHNU40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:56:26 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mq33i-1icEwC2vac-00nBpN; Wed, 14 Aug 2019 22:56:18 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-ppp@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5 13/18] compat_ioctl: move PPPIOCSCOMPRESS to ppp_generic
Date:   Wed, 14 Aug 2019 22:54:48 +0200
Message-Id: <20190814205521.122180-4-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190814204259.120942-1-arnd@arndb.de>
References: <20190814204259.120942-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:udnKTOM/1mbLHbQUn0rirIQLTUIu/NvLort76AdGfCbEvjij9Rk
 USgtylTUknlJaGhjBmz2nqZyCbQIYXNFPMTJH4ULrrssYAkJp/7sJL0fkltg22eIpao+6K1
 umR/cMUFd8rXt7+qoI4/zk1KeaNniBK24hYWshdgcodDZpZNMuQqkkJFMqGTjT1JdCK30PL
 gV0B9aMZNrMeNMyw7OO7A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zWgcd8uHvCo=:+3VhA5j2wTFJs1s/SEUYpw
 KCeo2xG4MKF0Be5k9nzt9GYHzSmwsPRm1t18w01/doFpLL9sfMWnYmwtTfySXJXJK8OjTbzXJ
 wr551CrrXcNf1Sj49t5jkpn0mf2mMXhvkPhu+CPOXk3ryranetpCWtnKQ7hAaGrLWeBYfg8dv
 lYujtQvHh4QTDUvzbeeB/JTlRr+ZoyX1hFnkuYl7eiMpXlhJR5RxpLsbEn66uZl5lZmdTsDzE
 jOkzQc4fnjOlZdaoqV6lHN2SVJBiArAVvWOLIbwTn/V2GMx+nGPUtpZc5HGBTHm3dRH+Apvnb
 /FcXrp+/KwOZLhfv6oKJlxScew6FX8f5kQ52PbOO5kNZCe9qPr4kXdeKeuzpyPI+iUpCbWwqA
 riH3MtzZWD8gl3nJi4G8fficgbzGALFBb08eQ0zJdWn5j8yJz2/8X2yqnok+zRgW5rAveI+Rt
 mAyqmFGBZ2To1bHW29VJ+tO17yZvpSmUPULfnl/+Id0HaISF4jnUlcW4fuLDPXHreLqlqo2Z+
 Nk2nvBq3zCBxqxVaKOlA75Yqv7UDPQDaOnTCWQ5RafgvPPaijwAtOmEd+jvnw8H3XlD/0CbgY
 yG0JgXMi97/UYmQc5PZRAn2u+UpXLGh2gCsnZB/8GE43bCqqLHHpwsikQRNvOm5WOZ8cLzIMS
 JdmMrqe4OzA+FL5BSNwjOAfxVEgPcDwhrAunKJGsgtmUW1E0xIjRbVZMET0oQyaGG0XyWPAA5
 3N3TXz1PUeM0DYfguvEPwrW8byNuVlZDcFRluQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Rather than using a compat_alloc_user_space() buffer, moving
this next to the native handler allows sharing most of
the code, leaving only the user copy portion distinct.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ppp/ppp_generic.c | 53 +++++++++++++++++++++++++----------
 fs/compat_ioctl.c             | 32 ---------------------
 2 files changed, 38 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index e3f207767589..2ab67bad6224 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -270,7 +270,7 @@ static void ppp_mp_insert(struct ppp *ppp, struct sk_buff *skb);
 static struct sk_buff *ppp_mp_reconstruct(struct ppp *ppp);
 static int ppp_mp_explode(struct ppp *ppp, struct sk_buff *skb);
 #endif /* CONFIG_PPP_MULTILINK */
-static int ppp_set_compress(struct ppp *ppp, unsigned long arg);
+static int ppp_set_compress(struct ppp *ppp, struct ppp_option_data *data);
 static void ppp_ccp_peek(struct ppp *ppp, struct sk_buff *skb, int inbound);
 static void ppp_ccp_closed(struct ppp *ppp);
 static struct compressor *find_compressor(int type);
@@ -708,9 +708,14 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 
 	case PPPIOCSCOMPRESS:
-		err = ppp_set_compress(ppp, arg);
+	{
+		struct ppp_option_data data;
+		if (copy_from_user(&data, argp, sizeof(data)))
+			err = -EFAULT;
+		else
+			err = ppp_set_compress(ppp, &data);
 		break;
-
+	}
 	case PPPIOCGUNIT:
 		if (put_user(ppp->file.index, p))
 			break;
@@ -827,6 +832,13 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 }
 
 #ifdef CONFIG_COMPAT
+struct ppp_option_data32 {
+	compat_uptr_t		ptr;
+	u32			length;
+	compat_int_t		transmit;
+};
+#define PPPIOCSCOMPRESS32	_IOW('t', 77, struct ppp_option_data32)
+
 static long ppp_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct ppp_file *pf;
@@ -863,6 +875,21 @@ static long ppp_compat_ioctl(struct file *file, unsigned int cmd, unsigned long
 			break;
 		}
 #endif /* CONFIG_PPP_FILTER */
+		case PPPIOCSCOMPRESS32:
+		{
+			struct ppp_option_data32 data32;
+			if (copy_from_user(&data32, argp, sizeof(data32))) {
+				err = -EFAULT;
+			} else {
+				struct ppp_option_data data = {
+					.ptr = compat_ptr(data32.ptr),
+					.length = data32.length,
+					.transmit = data32.transmit
+				};
+				err = ppp_set_compress(ppp, &data);
+			}
+			break;
+		}
 		}
 	}
 	mutex_unlock(&ppp_mutex);
@@ -2781,24 +2808,20 @@ ppp_output_wakeup(struct ppp_channel *chan)
 
 /* Process the PPPIOCSCOMPRESS ioctl. */
 static int
-ppp_set_compress(struct ppp *ppp, unsigned long arg)
+ppp_set_compress(struct ppp *ppp, struct ppp_option_data *data)
 {
-	int err;
+	int err = -EFAULT;
 	struct compressor *cp, *ocomp;
-	struct ppp_option_data data;
 	void *state, *ostate;
 	unsigned char ccp_option[CCP_MAX_OPTION_LENGTH];
 
-	err = -EFAULT;
-	if (copy_from_user(&data, (void __user *) arg, sizeof(data)))
-		goto out;
-	if (data.length > CCP_MAX_OPTION_LENGTH)
+	if (data->length > CCP_MAX_OPTION_LENGTH)
 		goto out;
-	if (copy_from_user(ccp_option, (void __user *) data.ptr, data.length))
+	if (copy_from_user(ccp_option, data->ptr, data->length))
 		goto out;
 
 	err = -EINVAL;
-	if (data.length < 2 || ccp_option[1] < 2 || ccp_option[1] > data.length)
+	if (data->length < 2 || ccp_option[1] < 2 || ccp_option[1] > data->length)
 		goto out;
 
 	cp = try_then_request_module(
@@ -2808,8 +2831,8 @@ ppp_set_compress(struct ppp *ppp, unsigned long arg)
 		goto out;
 
 	err = -ENOBUFS;
-	if (data.transmit) {
-		state = cp->comp_alloc(ccp_option, data.length);
+	if (data->transmit) {
+		state = cp->comp_alloc(ccp_option, data->length);
 		if (state) {
 			ppp_xmit_lock(ppp);
 			ppp->xstate &= ~SC_COMP_RUN;
@@ -2827,7 +2850,7 @@ ppp_set_compress(struct ppp *ppp, unsigned long arg)
 			module_put(cp->owner);
 
 	} else {
-		state = cp->decomp_alloc(ccp_option, data.length);
+		state = cp->decomp_alloc(ccp_option, data->length);
 		if (state) {
 			ppp_recv_lock(ppp);
 			ppp->rstate &= ~SC_DECOMP_RUN;
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index eda41b2537f0..0b5a732d7afd 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -99,13 +99,6 @@ static int sg_grt_trans(struct file *file,
 }
 #endif /* CONFIG_BLOCK */
 
-struct ppp_option_data32 {
-	compat_caddr_t	ptr;
-	u32			length;
-	compat_int_t		transmit;
-};
-#define PPPIOCSCOMPRESS32	_IOW('t', 77, struct ppp_option_data32)
-
 struct ppp_idle32 {
 	compat_time_t xmit_idle;
 	compat_time_t recv_idle;
@@ -133,29 +126,6 @@ static int ppp_gidle(struct file *file, unsigned int cmd,
 	return err;
 }
 
-static int ppp_scompress(struct file *file, unsigned int cmd,
-	struct ppp_option_data32 __user *odata32)
-{
-	struct ppp_option_data __user *odata;
-	__u32 data;
-	void __user *datap;
-
-	odata = compat_alloc_user_space(sizeof(*odata));
-
-	if (get_user(data, &odata32->ptr))
-		return -EFAULT;
-
-	datap = compat_ptr(data);
-	if (put_user(datap, &odata->ptr))
-		return -EFAULT;
-
-	if (copy_in_user(&odata->length, &odata32->length,
-			 sizeof(__u32) + sizeof(int)))
-		return -EFAULT;
-
-	return do_ioctl(file, PPPIOCSCOMPRESS, (unsigned long) odata);
-}
-
 /*
  * simple reversible transform to make our table more evenly
  * distributed after sorting.
@@ -249,8 +219,6 @@ static long do_ioctl_trans(unsigned int cmd,
 	switch (cmd) {
 	case PPPIOCGIDLE32:
 		return ppp_gidle(file, cmd, argp);
-	case PPPIOCSCOMPRESS32:
-		return ppp_scompress(file, cmd, argp);
 #ifdef CONFIG_BLOCK
 	case SG_GET_REQUEST_TABLE:
 		return sg_grt_trans(file, cmd, argp);
-- 
2.20.0

