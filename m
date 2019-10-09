Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE04BD184E
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732393AbfJITNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:13:10 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:48377 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731996AbfJITL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:11:27 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MsZ7T-1hyQGR3c9T-00typw; Wed, 09 Oct 2019 21:11:20 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v6 37/43] compat_ioctl: unify copy-in of ppp filters
Date:   Wed,  9 Oct 2019 21:10:38 +0200
Message-Id: <20191009191044.308087-38-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191009190853.245077-1-arnd@arndb.de>
References: <20191009190853.245077-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:YMQu2SzBTiUnl+nOpaa6B39uqrCnG7+R1LtL31k9mGcKtqSfrg6
 FR1Fj/jteJ2YpBnZBouGG9EsztZJw9RGZEG3Do5JL+wTZPVxFOatKmmkxlHU/MQwf+O6SK7
 0skHgu2EesoaX09tmD//3Y5GbdHkd1UnLw2iVQru7pPk22Rt6XcBvcNJUkZXmYEjpG/9Jai
 SQTRHLA8Dc/e6JbkA6mRg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hkE1iLX/yck=:86kzB3AfhM/d2NpCuZ3D2K
 vjFGsdPrGn8xVqWB8+8XgYVaNsQvgDJ/ttjNgcL0L1FVFsmrUDtBs+CTKjzv5/5FRceh3COlt
 Oa/sa/tFgwWLDQnoJkacgpBcndlLUbxdy2KWQzrhtMiR9CSbq75M59np6gcspy0ZL7nC2NftZ
 uIPZyU+Ugmxh7Em+8/0LhXCmKOOhCA94h+q7YC7DX6Lr48qsEvFlh2ppUsMdyqlJ6mOfuiN/A
 I92e9VtIgnZ0r4Zz1eE04VQKOCnbtS7N3bwQ5lXnygCeMUWdfCYoa1pavYf3DFCVbuzzwO1LZ
 hK3AaCKwOW9PJBlP5AzS6HnaCQYFTPgtRpeECh0pIHAjQhyJOnacbfO5H2NloZ5pw7gFT6N0p
 A1vqoEopUzCTOO9XjtskT0uNcQubRwr82H2WfoG81hfSb8e+tGJzbCcR1pvLk/DHHqhd0H7+p
 NYGdjT9PQmfn0bLUqiAkCjULcy6YBJ7JQ3N1qoyPoZUqpZ6qKqre+fhFWkGMThww983xx6/C/
 YkIuoOCb23sU1ifsDjPKvAob4LktjIu9ZwmNnfp75WQTfv6XWE35fxf5Vns8F18NXtK07G9dp
 ahlkCzxAlVOclhGPAHHV+Ua8qx+ujIW5KOM5XmMZv6Xw4F1gB/M39Kh0e4aSw924xue3plPig
 DkHeLTu1iobYu8XuKI5nNIcd/AAAFLl7jPk+GXZSMQlMZHaE/bv4u9OH4bP3FMsv2mkPXNjic
 Bp6FkNPfrD2JQ0MC+vqzWi/cXKYegcq5ey3ecmj49oxT6hrcfvH79uUpKbOOmOaFBDcZTrxQ7
 X4cTwcgEuk8fW2ry4mtWCoxYtRqlvkZkiNHDVl7Mq0SrSQHgLqlIZ4yDDiESLhWGddfJqH13t
 rjuFVu9gVfDbqkO1Txgw==
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
Cc: netdev@vger.kernel.org
Cc: linux-ppp@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ppp/ppp_generic.c | 169 ++++++++++++++++++++++------------
 fs/compat_ioctl.c             |  37 --------
 2 files changed, 108 insertions(+), 98 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 9a1b006904a7..7f8430e6b137 100644
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

