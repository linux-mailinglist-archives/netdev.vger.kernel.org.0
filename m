Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5DB6B9B77
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCNQ36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjCNQ3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:29:32 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61587686;
        Tue, 14 Mar 2023 09:29:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 58F34219FF;
        Tue, 14 Mar 2023 16:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678811366; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AOXs8HMvcdU3nxYO1lc5nB+xUvOimCpEaWjS7uF8Y3g=;
        b=1/QYBdJEBoPsOa4Ti/d2D4/xufy8a5g0DTHkUPP1hur6lLZfluwcjO09sLHfYBvdITnGo7
        4aIVIB6GM+4H5FA783SOqL4fhCJBiRkuyZZTYzvdrSH6skWPRZpI8FYdKcbmKxuf+bd45x
        IK4voxBzsk3BEkjkEfb8HxQD6EYRlk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678811366;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AOXs8HMvcdU3nxYO1lc5nB+xUvOimCpEaWjS7uF8Y3g=;
        b=ufcTA+AXdJBXkhB3tCGTe8Z5uc0ZBHifUjCSQHHCE9KFSl3o70mjDXZdttEwFFtkYvBzHO
        I1RaLUzaR75qPKDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 379F113A26;
        Tue, 14 Mar 2023 16:29:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XPHjDOagEGRqZQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Mar 2023 16:29:26 +0000
Message-ID: <82eb95ac-2dca-7a7a-116a-2771c4551bab@suse.de>
Date:   Tue, 14 Mar 2023 17:29:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 5/9] iscsi: set netns for iscsi_tcp hosts
Content-Language: en-US
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <566c527d12f6ed56eeb40952fef7431a0ccdc78f.1675876735.git.lduncan@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <566c527d12f6ed56eeb40952fef7431a0ccdc78f.1675876735.git.lduncan@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 18:40, Lee Duncan wrote:
> From: Lee Duncan <lduncan@suse.com>
> 
> This lets iscsi_tcp operate in multiple namespaces.  It uses current
> during session creation to find the net namespace, but it might be
> better to manage to pass it along from the iscsi netlink socket.
> 
And indeed, I'd rather use the namespace from the iscsi netlink socket.
If you use the namespace from session creation you'd better hope that
this function is not called from a workqueue ...


> Signed-off-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/scsi/iscsi_tcp.c            | 7 +++++++
>   drivers/scsi/scsi_transport_iscsi.c | 7 ++++++-
>   include/scsi/scsi_transport_iscsi.h | 1 +
>   3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 0454d94e8cf0..22e7a5c93627 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -1069,6 +1069,11 @@ static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
>   	return 0;
>   }
>   
> +static struct net *iscsi_sw_tcp_netns(struct Scsi_Host *shost)
> +{
> +	return current->nsproxy->net_ns;
> +}
> +

See above if you can't reference the namespace for the netlink socket here.

>   static struct scsi_host_template iscsi_sw_tcp_sht = {
>   	.module			= THIS_MODULE,
>   	.name			= "iSCSI Initiator over TCP/IP",
> @@ -1124,6 +1129,8 @@ static struct iscsi_transport iscsi_sw_tcp_transport = {
>   	.alloc_pdu		= iscsi_sw_tcp_pdu_alloc,
>   	/* recovery */
>   	.session_recovery_timedout = iscsi_session_recovery_timedout,
> +	/* net namespace */
> +	.get_netns		= iscsi_sw_tcp_netns,
>   };
>   
>   static int __init iscsi_sw_tcp_init(void)
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 230b43d34c5f..996a9abfa1f5 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1600,10 +1600,15 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
>   {
>   	struct Scsi_Host *shost = dev_to_shost(dev);
>   	struct iscsi_cls_host *ihost = shost->shost_data;
> +	struct iscsi_internal *priv = to_iscsi_internal(shost->transportt);
> +	struct iscsi_transport *transport = priv->iscsi_transport;
>   
>   	memset(ihost, 0, sizeof(*ihost));
>   	mutex_init(&ihost->mutex);
> -	ihost->netns = &init_net;
> +	if (transport->get_netns)
> +		ihost->netns = transport->get_netns(shost);
> +	else
> +		ihost->netns = &init_net;
>   
>   	iscsi_bsg_host_add(shost, ihost);
>   	/* ignore any bsg add error - we just can't do sgio */
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index af0c5a15f316..f8885d0c37d8 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -156,6 +156,7 @@ struct iscsi_transport {
>   	int (*logout_flashnode_sid) (struct iscsi_cls_session *cls_sess);
>   	int (*get_host_stats) (struct Scsi_Host *shost, char *buf, int len);
>   	u8 (*check_protection)(struct iscsi_task *task, sector_t *sector);
> +	struct net *(*get_netns)(struct Scsi_Host *shost);
>   };
>   
>   /*

Cheers,

Hannes

