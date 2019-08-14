Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB928DF73
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbfHNU4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:56:06 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60957 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728443AbfHNU4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:56:06 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M4K2r-1hyHIH0iDh-000MQ2; Wed, 14 Aug 2019 22:56:00 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v5 12/18] compat_ioctl: unify copy-in of ppp filters
Date:   Wed, 14 Aug 2019 22:54:47 +0200
Message-Id: <20190814205521.122180-3-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190814204259.120942-1-arnd@arndb.de>
References: <20190814204259.120942-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:gweRwe3qoOfci1cVCHomKaMjKCeIGffZck0PcdeiHARYsh64WGz
 upSLT8xxKvAMj7GeXMKh8qZRYj3HKzPwEtlBatIM5V0lJdkWWu++ZDiIQiqWKMKxQF528up
 diRaGWM7UeH9O7Ovc54jU3fY41LJbxW6jks8NGuvhbepvO3gMuTbwycWxAstgnQkLEWs5IL
 2QFLdzKY58dgL7NzJLu7g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qbgXzQj+UpM=:nbb7CErS1GX4es59ymPfuC
 hKqDGMbDByRk6H8a/qM4epEHrtxYj3vUP2bIvviABQZXMrheOHOLMpQUQ/aZf1PJlsCN6pNxs
 yAq3JDSkqGcg5g8UGWYygW2wlZhbKM9LgyCZf3qAdeLbP405B+fuFGO+ocrwXc/DC4KD9REfm
 fXx6vyK7H3ilGKG/00ErzYhLgSLge+3yH/9RDw8IQNfbq1JH4M/BnrlbQdVgoN5NILd9oITbC
 2yTXyRgnUi8LrA2uuKURV0P2t1yImAiTMZPqVUywP9V2CZYJbQX3wGmbuEkW56BYzcL8140vj
 j0nhZ2kTvZo2ADBcJ+50wF0i9mdvqNmFON2gWzG9IJCmXqsQdOf9TsT63S5AMits+gQ0FVGg/
 mV/va9xv0ZtOHfB0EeyCpEkBiCyKPK961+U0xcp5TRiRrxapcVm0a6si6xnZ2+HMfpdcxQcJK
 4/wdQPRTBy9ec7rXvl4f/Ui9240L463MhLw3sigcLr91FCmJqe8Wpv16UgaGODTfPNNjmZomX
 SHIzG8Yujp2ClNw0VVSe6mlla++Kc0Si5aUyD8vkFna56GaZXDdBrGlzUsNKd5nwkjf3eENRY
 YSR4LwMq9suARgyqclDMiCgUaV1nYe84vyCZ9V/f6TfR5z+Jbz6h90j7M6OUnLJW++wNUsYHs
 SV0m709ZFcB8JkvIvDCiG6WcG5wNRAqnlcA9dblULrNtwK0bEub5dQN+I4fwmdMPMkQU4WZ3K
 p0pOKIa2dCzMyTozjBZZy+cHBQyWhgA1+N4QuA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Now that isdn4linux is gone, the is only one implementation of PPPIOCSPASS
and PPPIOCSACTIVE in ppp_generic.c, so this is where the compat_ioctl
support should be implemented.

The two commands are implemented in very similar ways, so introduce
new helpers to allow sharing between the two and between native and
compat mode.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[arnd: rebased, and added changelog text]
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ppp/ppp_generic.c | 169 ++++++++++++++++++++++------------
 fs/compat_ioctl.c             |  37 --------
 2 files changed, 108 insertions(+), 98 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index a30e41a56085..e3f207767589 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -554,29 +554,58 @@ static __poll_t ppp_poll(struct file *file, poll_table *wait)
 }
 
 #ifdef CONFIG_PPP_FILTER
-static int get_filter(void __user *arg, struct sock_filter **p)
+static struct bpf_prog *get_filter(struct sock_fprog *uprog)
+{
+	struct sock_fprog_kern fprog;
+	struct bpf_prog *res = NULL;
+	int err;
+
+	if (!uprog->len)
+		return NULL;
+
+	/* uprog->len is unsigned short, so no overflow here */
+	fprog.len = uprog->len * sizeof(struct sock_filter);
+	fprog.filter = memdup_user(uprog->filter, fprog.len);
+	if (IS_ERR(fprog.filter))
+		return ERR_CAST(fprog.filter);
+
+	err = bpf_prog_create(&res, &fprog);
+	kfree(fprog.filter);
+
+	return err ? ERR_PTR(err) : res;
+}
+
+static struct bpf_prog *ppp_get_filter(struct sock_fprog __user *p)
 {
 	struct sock_fprog uprog;
-	struct sock_filter *code = NULL;
-	int len;
 
-	if (copy_from_user(&uprog, arg, sizeof(uprog)))
-		return -EFAULT;
+	if (copy_from_user(&uprog, p, sizeof(struct sock_fprog)))
+		return ERR_PTR(-EFAULT);
+	return get_filter(&uprog);
+}
 
-	if (!uprog.len) {
-		*p = NULL;
-		return 0;
-	}
+#ifdef CONFIG_COMPAT
+struct sock_fprog32 {
+	unsigned short len;
+	compat_caddr_t filter;
+};
 
-	len = uprog.len * sizeof(struct sock_filter);
-	code = memdup_user(uprog.filter, len);
-	if (IS_ERR(code))
-		return PTR_ERR(code);
+#define PPPIOCSPASS32		_IOW('t', 71, struct sock_fprog32)
+#define PPPIOCSACTIVE32		_IOW('t', 70, struct sock_fprog32)
 
-	*p = code;
-	return uprog.len;
+static struct bpf_prog *compat_ppp_get_filter(struct sock_fprog32 __user *p)
+{
+	struct sock_fprog32 uprog32;
+	struct sock_fprog uprog;
+
+	if (copy_from_user(&uprog32, p, sizeof(struct sock_fprog32)))
+		return ERR_PTR(-EFAULT);
+	uprog.len = uprog32.len;
+	uprog.filter = compat_ptr(uprog32.filter);
+	return get_filter(&uprog);
 }
-#endif /* CONFIG_PPP_FILTER */
+#endif
+#endif
 
 static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
@@ -753,55 +782,25 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 #ifdef CONFIG_PPP_FILTER
 	case PPPIOCSPASS:
-	{
-		struct sock_filter *code;
-
-		err = get_filter(argp, &code);
-		if (err >= 0) {
-			struct bpf_prog *pass_filter = NULL;
-			struct sock_fprog_kern fprog = {
-				.len = err,
-				.filter = code,
-			};
-
-			err = 0;
-			if (fprog.filter)
-				err = bpf_prog_create(&pass_filter, &fprog);
-			if (!err) {
-				ppp_lock(ppp);
-				if (ppp->pass_filter)
-					bpf_prog_destroy(ppp->pass_filter);
-				ppp->pass_filter = pass_filter;
-				ppp_unlock(ppp);
-			}
-			kfree(code);
-		}
-		break;
-	}
 	case PPPIOCSACTIVE:
 	{
-		struct sock_filter *code;
+		struct bpf_prog *filter = ppp_get_filter(argp);
+		struct bpf_prog **which;
 
-		err = get_filter(argp, &code);
-		if (err >= 0) {
-			struct bpf_prog *active_filter = NULL;
-			struct sock_fprog_kern fprog = {
-				.len = err,
-				.filter = code,
-			};
-
-			err = 0;
-			if (fprog.filter)
-				err = bpf_prog_create(&active_filter, &fprog);
-			if (!err) {
-				ppp_lock(ppp);
-				if (ppp->active_filter)
-					bpf_prog_destroy(ppp->active_filter);
-				ppp->active_filter = active_filter;
-				ppp_unlock(ppp);
-			}
-			kfree(code);
+		if (IS_ERR(filter)) {
+			err = PTR_ERR(filter);
+			break;
 		}
+		if (cmd == PPPIOCSPASS)
+			which = &ppp->pass_filter;
+		else
+			which = &ppp->active_filter;
+		ppp_lock(ppp);
+		if (*which)
+			bpf_prog_destroy(*which);
+		*which = filter;
+		ppp_unlock(ppp);
+		err = 0;
 		break;
 	}
 #endif /* CONFIG_PPP_FILTER */
@@ -827,6 +826,51 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return err;
 }
 
+#ifdef CONFIG_COMPAT
+static long ppp_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct ppp_file *pf;
+	int err = -ENOIOCTLCMD;
+	void __user *argp = (void __user *)arg;
+
+	mutex_lock(&ppp_mutex);
+
+	pf = file->private_data;
+	if (pf && pf->kind == INTERFACE) {
+		struct ppp *ppp = PF_TO_PPP(pf);
+		switch (cmd) {
+#ifdef CONFIG_PPP_FILTER
+		case PPPIOCSPASS32:
+		case PPPIOCSACTIVE32:
+		{
+			struct bpf_prog *filter = compat_ppp_get_filter(argp);
+			struct bpf_prog **which;
+
+			if (IS_ERR(filter)) {
+				err = PTR_ERR(filter);
+				break;
+			}
+			if (cmd == PPPIOCSPASS32)
+				which = &ppp->pass_filter;
+			else
+				which = &ppp->active_filter;
+			ppp_lock(ppp);
+			if (*which)
+				bpf_prog_destroy(*which);
+			*which = filter;
+			ppp_unlock(ppp);
+			err = 0;
+			break;
+		}
+#endif /* CONFIG_PPP_FILTER */
+		}
+	}
+	mutex_unlock(&ppp_mutex);
+
+	return err;
+}
+#endif
+
 static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
 			struct file *file, unsigned int cmd, unsigned long arg)
 {
@@ -895,6 +939,9 @@ static const struct file_operations ppp_device_fops = {
 	.write		= ppp_write,
 	.poll		= ppp_poll,
 	.unlocked_ioctl	= ppp_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= ppp_compat_ioctl,
+#endif
 	.open		= ppp_open,
 	.release	= ppp_release,
 	.llseek		= noop_llseek,
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index d537888f3660..eda41b2537f0 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -99,40 +99,6 @@ static int sg_grt_trans(struct file *file,
 }
 #endif /* CONFIG_BLOCK */
 
-struct sock_fprog32 {
-	unsigned short	len;
-	compat_caddr_t	filter;
-};
-
-#define PPPIOCSPASS32	_IOW('t', 71, struct sock_fprog32)
-#define PPPIOCSACTIVE32	_IOW('t', 70, struct sock_fprog32)
-
-static int ppp_sock_fprog_ioctl_trans(struct file *file,
-		unsigned int cmd, struct sock_fprog32 __user *u_fprog32)
-{
-	struct sock_fprog __user *u_fprog64 = compat_alloc_user_space(sizeof(struct sock_fprog));
-	void __user *fptr64;
-	u32 fptr32;
-	u16 flen;
-
-	if (get_user(flen, &u_fprog32->len) ||
-	    get_user(fptr32, &u_fprog32->filter))
-		return -EFAULT;
-
-	fptr64 = compat_ptr(fptr32);
-
-	if (put_user(flen, &u_fprog64->len) ||
-	    put_user(fptr64, &u_fprog64->filter))
-		return -EFAULT;
-
-	if (cmd == PPPIOCSPASS32)
-		cmd = PPPIOCSPASS;
-	else
-		cmd = PPPIOCSACTIVE;
-
-	return do_ioctl(file, cmd, (unsigned long) u_fprog64);
-}
-
 struct ppp_option_data32 {
 	compat_caddr_t	ptr;
 	u32			length;
@@ -285,9 +251,6 @@ static long do_ioctl_trans(unsigned int cmd,
 		return ppp_gidle(file, cmd, argp);
 	case PPPIOCSCOMPRESS32:
 		return ppp_scompress(file, cmd, argp);
-	case PPPIOCSPASS32:
-	case PPPIOCSACTIVE32:
-		return ppp_sock_fprog_ioctl_trans(file, cmd, argp);
 #ifdef CONFIG_BLOCK
 	case SG_GET_REQUEST_TABLE:
 		return sg_grt_trans(file, cmd, argp);
-- 
2.20.0

