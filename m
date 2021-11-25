Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E677945D388
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345367AbhKYDUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:20:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244448AbhKYDSO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 22:18:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB4C460234;
        Thu, 25 Nov 2021 03:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637810104;
        bh=yllRDDNr8XZGAHhiOK0XY3jsanMZmwDiDUkOfVa7CwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N6ry+ZgNibe4aNi3FqKwSBtUZTBld9amjc0FzGg/4v18dwQj0sF+1qlyIcSQKF8ax
         o215+/lg7eadYb+gDJaep8mZcxUokp2nimK5oaakcmXKcyc5JMyh8+DB55EuF0UDDz
         2liGvWpNPQzw8qSreiRpvMC6BzSDjVU7U9jwFhaZC2FGLdxD3jtq7uYO4SwKf/WEVo
         VFJ18mQQI6rFZKxa+KUHrb4s6p4m2HGjNVENanw2RwdhWhUh8/3wRNS5c99dBFD4W8
         R6zCahzmiwhlM/pYhuWVppb+pUrDnPubltV7+1pdWvAtBQZ7Ih+GziK8YJXWFAfCsv
         d25GUmNXhUwdQ==
Date:   Wed, 24 Nov 2021 19:15:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: Re: [PATCH net-next 1/3] net: prestera: acl: migrate to new vTCAM
 api
Message-ID: <20211124191502.5b497e84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1637686684-2492-2-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1637686684-2492-1-git-send-email-volodymyr.mytnyk@plvision.eu>
        <1637686684-2492-2-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 18:58:00 +0200 Volodymyr Mytnyk wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> - Add new vTCAM HW API to configure HW ACLs.
> - Migrate acl to use new vTCAM HW API.
> - No counter support in this patch-set.
> 
> Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>

>  struct prestera_acl_ruleset {
> +	struct rhash_head ht_node; /* Member of acl HT */
> +	struct prestera_acl_ruleset_ht_key ht_key;
>  	struct rhashtable rule_ht;
> -	struct prestera_switch *sw;
> -	u16 id;
> +	struct prestera_acl *acl;
> +	unsigned long rule_count;
> +	refcount_t refcount;
> +	void *keymask;
> +	bool offload;
> +	u32 vtcam_id;
> +	u16 pcl_id;

put the pcl_id earlier for better packing?

>  };

> +struct prestera_acl_vtcam {
> +	struct list_head list;
> +	__be32 keymask[__PRESTERA_ACL_RULE_MATCH_TYPE_MAX];
> +	bool is_keymask_set;
> +	refcount_t refcount;
> +	u8 lookup;

same here, 1B types together

>  	u32 id;
>  };

> +int prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
> +				     void *keymask)
>  {
> -	prestera_hw_acl_ruleset_del(ruleset->sw, ruleset->id);
> -	rhashtable_destroy(&ruleset->rule_ht);
> -	kfree(ruleset);
> +	void *__keymask;
> +
> +	if (!keymask || !ruleset)

Can this legitimately happen? No defensive programming, please.

> +		return -EINVAL;
> +
> +	__keymask = kmalloc(ACL_KEYMASK_SIZE, GFP_KERNEL);
> +	if (!__keymask)
> +		return -ENOMEM;
> +
> +	memcpy(__keymask, keymask, ACL_KEYMASK_SIZE);

kmemdup()

> +	ruleset->keymask = __keymask;
> +
> +	return 0;
>  }
