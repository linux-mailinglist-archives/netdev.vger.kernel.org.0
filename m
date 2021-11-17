Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE35454DC8
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 20:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhKQTWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 14:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240435AbhKQTWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 14:22:00 -0500
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4350EC061570;
        Wed, 17 Nov 2021 11:19:01 -0800 (PST)
Received: by fieldses.org (Postfix, from userid 2815)
        id 66B78AA2; Wed, 17 Nov 2021 14:19:00 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org 66B78AA2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1637176740;
        bh=XegTj+Eod+M5qbOBKOmiPBRETDeArw5dFEvi5OplikQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jgBi4CVrbLjryvZ9XketbN9D6BftLZTVMwUYQzKpk1GT1Hsb5HnnVk1PKKYU8wl/d
         q2VB2JSjP3qynPlBDmt0tvQar8G6mN/ZoWs3y4KhT3EX1hJNj5EV9CN9wvKSmSdfTp
         Q8cp2capdzmh8EwVL1x2E1DOZBRBnjWinu0DvHI0=
Date:   Wed, 17 Nov 2021 14:19:00 -0500
From:   "bfields@fieldses.org" <bfields@fieldses.org>
To:     "wanghai (M)" <wanghai38@huawei.com>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        "neilb@suse.com" <neilb@suse.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "tyhicks@canonical.com" <tyhicks@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "tom@talpey.com" <tom@talpey.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "timo@rothenpieler.org" <timo@rothenpieler.org>,
        "jiang.wang@bytedance.com" <jiang.wang@bytedance.com>,
        "kuniyu@amazon.co.jp" <kuniyu@amazon.co.jp>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rao.Shoaib@oracle.com" <Rao.Shoaib@oracle.com>,
        "wenbin.zeng@gmail.com" <wenbin.zeng@gmail.com>,
        "kolga@netapp.com" <kolga@netapp.com>
Subject: Re: [PATCH net 2/2] auth_gss: Fix deadlock that blocks
 rpcsec_gss_exit_net when use-gss-proxy==1
Message-ID: <20211117191900.GE24762@fieldses.org>
References: <20210928134952.GA25415@fieldses.org>
 <77051a059fa19a7ae2390fbda7f8ab6f09514dfc.camel@hammerspace.com>
 <20210928141718.GC25415@fieldses.org>
 <cc92411f242290b85aa232e7220027b875942f30.camel@hammerspace.com>
 <20210928145747.GD25415@fieldses.org>
 <8b0e774bdb534c69b0612103acbe61c628fde9b1.camel@hammerspace.com>
 <20210928154300.GE25415@fieldses.org>
 <20210929211211.GC20707@fieldses.org>
 <ba12c503-401d-9b22-be83-7645c619d9d1@huawei.com>
 <20211109172111.GA5227@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211109172111.GA5227@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 12:21:11PM -0500, bfields@fieldses.org wrote:
> On Thu, Sep 30, 2021 at 09:56:03AM +0800, wanghai (M) wrote:
> > 
> > 在 2021/9/30 5:12, bfields@fieldses.org 写道:
> > >On Tue, Sep 28, 2021 at 11:43:00AM -0400, bfields@fieldses.org wrote:
> > >>On Tue, Sep 28, 2021 at 03:36:58PM +0000, Trond Myklebust wrote:
> > >>>What is the use case here? Starting the gssd daemon or knfsd in
> > >>>separate chrooted environments? We already know that they have to be
> > >>>started in the same net namespace, which pretty much ensures it has to
> > >>>be the same container.
> > >>Somehow I forgot that knfsd startup is happening in some real process's
> > >>context too (not just a kthread).
> > >>
> > >>OK, great, I agree, that sounds like it should work.
> 
> Ugh, took me a while to get back to this and I went down a couple dead
> ends.
> 
> The result from selinux's point of view is that rpc.nfsd is doing things
> it previously only expected gssproxy to do.  Fixable with an update to
> selinux policy.  And easily fixed in the meantime by cut-and-pasting the
> suggestions from the logs.
> 
> Still, the result's that mounts fail when you update the kernel, which
> seems a violation of our usual rules about regressions.  I'd like to do
> better.

So, I'm not applying this, but here's the patch, for what it's worth.

I'm not sure what the alternative is.  Do we get a chance to do
something when gssproxy closes the connection, maybe?

--b.

commit 9fc4ae28ec95
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Thu Nov 4 16:55:28 2021 -0400

    nfsd: connect to gssp-proxy on nfsd start
    
    We communicate with gss-proxy using by rpc over a local unix socket.
    The rpc client is set up in the context of the process that writes to
    /proc/net/rpc/use-gss-proxy.  Unfortunately that leaves us with no clear
    place to shut down that client; we've been trying to shut it down when
    the network namespace is destroyed, but the rpc client holds a reference
    on the network namespace, so that never happens.
    
    We do need to create the client in the context of a process that's
    likely to be in the correct namespace.  We can use rpc.nfsd instead.  In
    particular, we use create the rpc client when sockets are added to an
    rpc server.
    
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

diff --git a/include/linux/sunrpc/svcauth.h b/include/linux/sunrpc/svcauth.h
index 6d9cc9080aca..b60ecb51511d 100644
--- a/include/linux/sunrpc/svcauth.h
+++ b/include/linux/sunrpc/svcauth.h
@@ -183,4 +183,12 @@ static inline unsigned long hash_mem(char const *buf, int length, int bits)
 	return full_name_hash(NULL, buf, length) >> (32 - bits);
 }
 
+struct gssp_clnt_ops {
+	struct module *owner;
+	int (*constructor)(struct net*);
+	void (*destructor)(struct net*);
+};
+
+extern struct gssp_clnt_ops gpops;
+
 #endif /* _LINUX_SUNRPC_SVCAUTH_H_ */
diff --git a/net/sunrpc/auth_gss/gss_rpc_upcall.c b/net/sunrpc/auth_gss/gss_rpc_upcall.c
index 61c276bddaf2..04a311305b26 100644
--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -122,7 +122,6 @@ static int gssp_rpc_create(struct net *net, struct rpc_clnt **_clnt)
 
 void init_gssp_clnt(struct sunrpc_net *sn)
 {
-	mutex_init(&sn->gssp_lock);
 	sn->gssp_clnt = NULL;
 }
 
@@ -132,25 +131,23 @@ int set_gssp_clnt(struct net *net)
 	struct rpc_clnt *clnt;
 	int ret;
 
-	mutex_lock(&sn->gssp_lock);
-	ret = gssp_rpc_create(net, &clnt);
-	if (!ret) {
-		if (sn->gssp_clnt)
-			rpc_shutdown_client(sn->gssp_clnt);
+	if (!sn->gssp_clnt) {
+		ret = gssp_rpc_create(net, &clnt);
+		if (ret)
+			return ret;
 		sn->gssp_clnt = clnt;
 	}
-	mutex_unlock(&sn->gssp_lock);
-	return ret;
+	return 0;
 }
 
-void clear_gssp_clnt(struct sunrpc_net *sn)
+void clear_gssp_clnt(struct net *net)
 {
-	mutex_lock(&sn->gssp_lock);
+	struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
+
 	if (sn->gssp_clnt) {
 		rpc_shutdown_client(sn->gssp_clnt);
 		sn->gssp_clnt = NULL;
 	}
-	mutex_unlock(&sn->gssp_lock);
 }
 
 static struct rpc_clnt *get_gssp_clnt(struct sunrpc_net *sn)
diff --git a/net/sunrpc/auth_gss/gss_rpc_upcall.h b/net/sunrpc/auth_gss/gss_rpc_upcall.h
index 31e96344167e..fd70f4fb56a9 100644
--- a/net/sunrpc/auth_gss/gss_rpc_upcall.h
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.h
@@ -31,6 +31,6 @@ void gssp_free_upcall_data(struct gssp_upcall_data *data);
 
 void init_gssp_clnt(struct sunrpc_net *);
 int set_gssp_clnt(struct net *);
-void clear_gssp_clnt(struct sunrpc_net *);
+void clear_gssp_clnt(struct net *);
 
 #endif /* _GSS_RPC_UPCALL_H */
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 7dba6a9c213a..79212437558f 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1449,9 +1449,6 @@ static ssize_t write_gssp(struct file *file, const char __user *buf,
 		return res;
 	if (i != 1)
 		return -EINVAL;
-	res = set_gssp_clnt(net);
-	if (res)
-		return res;
 	res = set_gss_proxy(net, 1);
 	if (res)
 		return res;
@@ -1505,10 +1502,8 @@ static void destroy_use_gss_proxy_proc_entry(struct net *net)
 {
 	struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
 
-	if (sn->use_gssp_proc) {
+	if (sn->use_gssp_proc)
 		remove_proc_entry("use-gss-proxy", sn->proc_net_rpc);
-		clear_gssp_clnt(sn);
-	}
 }
 #else /* CONFIG_PROC_FS */
 
@@ -1999,9 +1994,16 @@ gss_svc_shutdown_net(struct net *net)
 	rsc_cache_destroy_net(net);
 }
 
+struct gssp_clnt_ops mygpops = {
+	.owner = THIS_MODULE,
+	.constructor = set_gssp_clnt,
+	.destructor = clear_gssp_clnt,
+};
+
 int
 gss_svc_init(void)
 {
+	gpops = mygpops;
 	return svc_auth_register(RPC_AUTH_GSS, &svcauthops_gss);
 }
 
@@ -2009,4 +2011,5 @@ void
 gss_svc_shutdown(void)
 {
 	svc_auth_unregister(RPC_AUTH_GSS);
+	gpops = mygpops;
 }
diff --git a/net/sunrpc/netns.h b/net/sunrpc/netns.h
index 7ec10b92bea1..7d8653b3d81b 100644
--- a/net/sunrpc/netns.h
+++ b/net/sunrpc/netns.h
@@ -28,6 +28,7 @@ struct sunrpc_net {
 	unsigned int rpcb_is_af_local : 1;
 
 	struct mutex gssp_lock;
+	int gssp_users;
 	struct rpc_clnt *gssp_clnt;
 	int use_gss_proxy;
 	int pipe_version;
diff --git a/net/sunrpc/sunrpc_syms.c b/net/sunrpc/sunrpc_syms.c
index 691c0000e9ea..463c975151d7 100644
--- a/net/sunrpc/sunrpc_syms.c
+++ b/net/sunrpc/sunrpc_syms.c
@@ -54,6 +54,8 @@ static __net_init int sunrpc_init_net(struct net *net)
 	INIT_LIST_HEAD(&sn->all_clients);
 	spin_lock_init(&sn->rpc_client_lock);
 	spin_lock_init(&sn->rpcb_clnt_lock);
+	mutex_init(&sn->gssp_lock);
+	sn->gssp_users = 0;
 	return 0;
 
 err_pipefs:
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 1e99ba1b9d72..30d9a9779093 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <trace/events/sunrpc.h>
+#include "netns.h"
 
 #define RPCDBG_FACILITY	RPCDBG_SVCXPRT
 
@@ -322,6 +323,37 @@ static int _svc_create_xprt(struct svc_serv *serv, const char *xprt_name,
 	return -EPROTONOSUPPORT;
 }
 
+struct gssp_clnt_ops gpops = {};
+EXPORT_SYMBOL_GPL(gpops);
+
+int get_gssp_clnt(struct net *net)
+{
+	struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
+	int ret;
+
+	mutex_lock(&sn->gssp_lock);
+
+	if (try_module_get(gpops.owner) && gpops.constructor(net)) {
+		ret = gpops.constructor(net);
+		module_put(gpops.owner);
+	}
+	sn->gssp_users++;
+	mutex_unlock(&sn->gssp_lock);
+
+	return ret;
+}
+
+void put_gssp_clnt(struct net *net)
+{
+	struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
+
+	mutex_lock(&sn->gssp_lock);
+	sn->gssp_users--;
+	if (!sn->gssp_users && sn->gssp_clnt)
+		gpops.destructor(net);
+	mutex_unlock(&sn->gssp_lock);
+}
+
 int svc_create_xprt(struct svc_serv *serv, const char *xprt_name,
 		    struct net *net, const int family,
 		    const unsigned short port, int flags,
@@ -329,11 +361,15 @@ int svc_create_xprt(struct svc_serv *serv, const char *xprt_name,
 {
 	int err;
 
+	get_gssp_clnt(net);
+
 	err = _svc_create_xprt(serv, xprt_name, net, family, port, flags, cred);
 	if (err == -EPROTONOSUPPORT) {
 		request_module("svc%s", xprt_name);
 		err = _svc_create_xprt(serv, xprt_name, net, family, port, flags, cred);
 	}
+	if (err < 0)
+		put_gssp_clnt(net);
 	return err;
 }
 EXPORT_SYMBOL_GPL(svc_create_xprt);
@@ -1038,6 +1074,7 @@ static void svc_delete_xprt(struct svc_xprt *xprt)
 {
 	struct svc_serv	*serv = xprt->xpt_server;
 	struct svc_deferred_req *dr;
+	struct net *net = xprt->xpt_net;
 
 	if (test_and_set_bit(XPT_DEAD, &xprt->xpt_flags))
 		return;
@@ -1058,6 +1095,8 @@ static void svc_delete_xprt(struct svc_xprt *xprt)
 		kfree(dr);
 
 	call_xpt_users(xprt);
+	if (!test_bit(XPT_TEMP, &xprt->xpt_flags))
+		put_gssp_clnt(net);
 	svc_xprt_put(xprt);
 }
 
