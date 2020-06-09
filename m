Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF69F1F4969
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 00:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgFIWcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 18:32:17 -0400
Received: from correo.us.es ([193.147.175.20]:33942 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbgFIWcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 18:32:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 22B7B1B49B1
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:32:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1330DDA797
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:32:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BA720DA87B; Wed, 10 Jun 2020 00:32:04 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E1A5DA856;
        Wed, 10 Jun 2020 00:32:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 10 Jun 2020 00:32:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D208D4251482;
        Wed, 10 Jun 2020 00:32:01 +0200 (CEST)
Date:   Wed, 10 Jun 2020 00:32:01 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     syzbot <syzbot+eb9d5924c51d6d59e094@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: memory leak in nf_tables_parse_netdev_hooks (3)
Message-ID: <20200609223201.GA29165@salvia>
References: <000000000000dbe05b05a7add269@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <000000000000dbe05b05a7add269@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 09, 2020 at 02:58:12PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1741f5f2100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9a1aa05456dfd557
> dashboard link: https://syzkaller.appspot.com/bug?extid=eb9d5924c51d6d59e094
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126f5446100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177f16fe100000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+eb9d5924c51d6d59e094@syzkaller.appspotmail.com

Attaching a quick patch, I will have a closer look later.

--ikeVEW9yuYc//A+q
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 073aa1051d43..5792e9dcd9bc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6550,12 +6550,22 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	return err;
 }
 
+static void nft_flowtable_hook_release(struct nft_flowtable_hook *flowtable_hook)
+{
+	struct nft_hook *this, *next;
+
+	list_for_each_entry_safe(this, next, &flowtable_hook->list, list) {
+		list_del(&this->list);
+		kfree(this);
+	}
+}
+
 static int nft_delflowtable_hook(struct nft_ctx *ctx,
 				 struct nft_flowtable *flowtable)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
-	struct nft_hook *this, *next, *hook;
+	struct nft_hook *this, *hook;
 	struct nft_trans *trans;
 	int err;
 
@@ -6564,33 +6574,40 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	list_for_each_entry_safe(this, next, &flowtable_hook.list, list) {
+	list_for_each_entry(this, &flowtable_hook.list, list) {
 		hook = nft_hook_list_find(&flowtable->hook_list, this);
 		if (!hook) {
 			err = -ENOENT;
 			goto err_flowtable_del_hook;
 		}
 		hook->inactive = true;
-		list_del(&this->list);
-		kfree(this);
 	}
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_DELFLOWTABLE,
 				sizeof(struct nft_trans_flowtable));
-	if (!trans)
-		return -ENOMEM;
+	if (!trans) {
+		err = -ENOMEM;
+		goto err_flowtable_del_hook;
+	}
 
 	nft_trans_flowtable(trans) = flowtable;
 	nft_trans_flowtable_update(trans) = true;
 	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
+	nft_flowtable_hook_release(&flowtable_hook);
 
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 
 	return 0;
 
 err_flowtable_del_hook:
-	list_for_each_entry(hook, &flowtable_hook.list, list)
+	list_for_each_entry(this, &flowtable->hook_list, list) {
+		hook = nft_hook_list_find(&flowtable->hook_list, this);
+		if (!hook)
+			break;
+
 		hook->inactive = false;
+	}
+	nft_flowtable_hook_release(&flowtable_hook);
 
 	return err;
 }

--ikeVEW9yuYc//A+q--
