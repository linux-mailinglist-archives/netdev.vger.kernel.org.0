Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911701F6639
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 13:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgFKLFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 07:05:42 -0400
Received: from correo.us.es ([193.147.175.20]:41094 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgFKLFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 07:05:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CAC4C10FB0C
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 13:05:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB40CDA84B
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 13:05:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BA520DA844; Thu, 11 Jun 2020 13:05:39 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7D6DFDA78E;
        Thu, 11 Jun 2020 13:05:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Jun 2020 13:05:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5BC1041E4800;
        Thu, 11 Jun 2020 13:05:37 +0200 (CEST)
Date:   Thu, 11 Jun 2020 13:05:37 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net v2] flow_offload: fix incorrect cleanup for indirect
 flow_blocks
Message-ID: <20200611110537.GA6047@salvia>
References: <1591869797-7264-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591869797-7264-1-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 06:03:17PM +0800, wenxu@ucloud.cn wrote:
[...]
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 0cfc35e..40eaf64 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -372,14 +372,13 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
>  }
>  EXPORT_SYMBOL(flow_indr_dev_register);
>  
> -static void __flow_block_indr_cleanup(flow_setup_cb_t *setup_cb, void *cb_priv,
> +static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
>  				      struct list_head *cleanup_list)
>  {
>  	struct flow_block_cb *this, *next;
>  
>  	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
> -		if (this->cb == setup_cb &&
> -		    this->cb_priv == cb_priv) {
> +		if (this->release == release) {

Are you sure this is correct?

This will remove _all_ existing representors in this driver.

This will not work if only one representor is gone?

Please, describe what scenario you are trying to fix.

Thank you.
