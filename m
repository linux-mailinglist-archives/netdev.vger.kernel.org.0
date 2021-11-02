Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D14E4430C9
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhKBOwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 10:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbhKBOwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 10:52:13 -0400
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B00C061714;
        Tue,  2 Nov 2021 07:49:36 -0700 (PDT)
Date:   Tue, 2 Nov 2021 15:49:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1635864573;
        bh=ZGMvUOgROs39Y2IRIABQgQtjLMkOhIgv7EWo6kdBvL4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WtoiCs3Ok0L6ElJs1cv+gVEIMDUM6+ZcXvWMRUR/2708Hh8iZYYUswLpgbAM/oU3P
         5Nbv3nAUsr/mOdTy0Pf1QOjg01OL0FzDJzHewkqfzbqVX2nIAvb05Uu6ycf8lat9uZ
         RHoBDMnEBpynIWVofT6yXipDAoq9UFbhcOGCg7xc=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: autoload transport modules
Message-ID: <ddf6b6c9-1d9b-4378-b2ee-b7ac4a622010@t-8ch.de>
References: <20211017134611.4330-1-linux@weissschuh.net>
 <YYEYMt543Hg+Hxzy@codewreck.org>
 <922a4843-c7b0-4cdc-b2a6-33bf089766e4@t-8ch.de>
 <YYEmOcEf5fjDyM67@codewreck.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2rCd6YTQfhfeI0Ff"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYEmOcEf5fjDyM67@codewreck.org>
Jabber-ID: thomas@t-8ch.de
X-Accept: text/plain, text/html;q=0.2, text/*;q=0.1
X-Accept-Language: en-us, en;q=0.8, de-de;q=0.7, de;q=0.6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2rCd6YTQfhfeI0Ff
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On 2021-11-02 20:51+0900, Dominique Martinet wrote:
> Thomas Weißschuh wrote on Tue, Nov 02, 2021 at 11:59:32AM +0100:
> > On 2021-11-02 19:51+0900, Dominique Martinet wrote:
> > > Sorry for the late reply
> > > 
> > > Thomas Weißschuh wrote on Sun, Oct 17, 2021 at 03:46:11PM +0200:
> > > > Automatically load transport modules based on the trans= parameter
> > > > passed to mount.
> > > > The removes the requirement for the user to know which module to use.
> > > 
> > > This looks good to me, I'll test this briefly on differnet config (=y,
> > > =m) and submit to Linus this week for the next cycle.
> > 
> > Thanks. Could you also fix up the typo in the commit message when applying?
> > ("The removes" -> "This removes")
> 
> Sure, done -- I hadn't even noticed it..
> 
> > > Makes me wonder why trans_fd is included in 9pnet and not in a 9pnet-fd
> > > or 9pnet-tcp module but that'll be for another time...
> > 
> > To prepare for the moment when those transport modules are split into their own
> > module(s), we could already add MODULE_ALIAS_9P() calls to net/9p/trans_fd.c.
> 
> I guess it wouldn't hurt to have 9p-tcp 9p-unix and 9p-fd aliases to the
> 9pnet module, but iirc these transports were more closely tied to the
> rest of 9pnet than the rest so it might take a while to do and I don't
> have much time for this right now...
> I'd rather not prepare for something I'll likely never get onto, so
> let's do this if there is progress.
> 
> Of course if you'd like to have a look that'd be more than welcome :-)

If you are still testing anyways, you could also try the attached patch.
(It requires the autload patch)

It builds fine and I see no reason for it not to work.

Thomas

--2rCd6YTQfhfeI0Ff
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="9p-transport-fd-module.patch"

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 03614de86942..f420f8cb378d 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -553,6 +553,4 @@ struct p9_fcall {
 int p9_errstr2errno(char *errstr, int len);
 
 int p9_error_init(void);
-int p9_trans_fd_init(void);
-void p9_trans_fd_exit(void);
 #endif /* NET_9P_H */
diff --git a/net/9p/Makefile b/net/9p/Makefile
index aa0a5641e5d0..b7d2ea495f65 100644
--- a/net/9p/Makefile
+++ b/net/9p/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_NET_9P) := 9pnet.o
+obj-$(CONFIG_NET_9P) += 9pnet_fd.o
 obj-$(CONFIG_NET_9P_XEN) += 9pnet_xen.o
 obj-$(CONFIG_NET_9P_VIRTIO) += 9pnet_virtio.o
 obj-$(CONFIG_NET_9P_RDMA) += 9pnet_rdma.o
@@ -9,9 +10,11 @@ obj-$(CONFIG_NET_9P_RDMA) += 9pnet_rdma.o
 	client.o \
 	error.o \
 	protocol.o \
-	trans_fd.o \
 	trans_common.o \
 
+9pnet_fd-objs := \
+	trans_fd.o \
+
 9pnet_virtio-objs := \
 	trans_virtio.o \
 
diff --git a/net/9p/mod.c b/net/9p/mod.c
index 5126566850bd..dee263f8e361 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -164,7 +164,6 @@ static int __init init_p9(void)
 
 	p9_error_init();
 	pr_info("Installing 9P2000 support\n");
-	p9_trans_fd_init();
 
 	return ret;
 }
@@ -178,7 +177,6 @@ static void __exit exit_p9(void)
 {
 	pr_info("Unloading 9P2000 support\n");
 
-	p9_trans_fd_exit();
 	p9_client_exit();
 }
 
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 007bbcc68010..ff95bdf8baa5 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -1092,6 +1092,7 @@ static struct p9_trans_module p9_tcp_trans = {
 	.show_options = p9_fd_show_options,
 	.owner = THIS_MODULE,
 };
+MODULE_ALIAS_9P("tcp");
 
 static struct p9_trans_module p9_unix_trans = {
 	.name = "unix",
@@ -1105,6 +1106,7 @@ static struct p9_trans_module p9_unix_trans = {
 	.show_options = p9_fd_show_options,
 	.owner = THIS_MODULE,
 };
+MODULE_ALIAS_9P("unix");
 
 static struct p9_trans_module p9_fd_trans = {
 	.name = "fd",
@@ -1118,6 +1120,7 @@ static struct p9_trans_module p9_fd_trans = {
 	.show_options = p9_fd_show_options,
 	.owner = THIS_MODULE,
 };
+MODULE_ALIAS_9P("fd");
 
 /**
  * p9_poll_workfn - poll worker thread
@@ -1167,3 +1170,10 @@ void p9_trans_fd_exit(void)
 	v9fs_unregister_trans(&p9_unix_trans);
 	v9fs_unregister_trans(&p9_fd_trans);
 }
+
+module_init(p9_trans_fd_init);
+module_exit(p9_trans_fd_exit);
+
+MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
+MODULE_DESCRIPTION("Filedescriptor Transport for 9P");
+MODULE_LICENSE("GPL");

--2rCd6YTQfhfeI0Ff--
