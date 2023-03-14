Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E36E6B9B48
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbjCNQYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjCNQXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:23:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC6E8FBEC;
        Tue, 14 Mar 2023 09:23:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 03E6E1F8A3;
        Tue, 14 Mar 2023 16:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678811007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jr7OykjRAT7+Ft2yWE+IrijNAsw/Y2JZKX2iXLtLrjg=;
        b=kYEh5XIaXoyyfKDMmRx+7oa/NPje9A9ifD6p3D/d138I6P1nG2GPATNWRsvl4EbtJa/3kl
        ZgMEo0SCH01p6mFUhj9wAzAhNd+intR5YYFYMQv4nvWztcPSX6l5REzpKiCWAs45zvPbJp
        HY/ThzAbItdc4pKXTN/RJ3Rd5FWpGyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678811007;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jr7OykjRAT7+Ft2yWE+IrijNAsw/Y2JZKX2iXLtLrjg=;
        b=KqLwTiFRGL5PCwCchTcEbpsV1guf9kX1Y85emFuJwjGd87BpqtVP3myEB0TDMSiCFR+T/a
        oF2T0qRZtHPd60Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DC7B813A26;
        Tue, 14 Mar 2023 16:23:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aN8rNX6fEGRdYgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Mar 2023 16:23:26 +0000
Message-ID: <a9f8cc4f-5d60-be5e-d294-c4a9baa16ec4@suse.de>
Date:   Tue, 14 Mar 2023 17:23:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC PATCH 2/9] iscsi: associate endpoints with a host
Content-Language: en-US
To:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org
Cc:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <154c7602b3cc59f8af44439249ea5e5eb75f92d3.1675876734.git.lduncan@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <154c7602b3cc59f8af44439249ea5e5eb75f92d3.1675876734.git.lduncan@suse.com>
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
> Right now the iscsi_endpoint is only linked to a connection once that
> connection has been established.  For net namespace filtering of the
> sysfs objects, associate an endpoint with the host that it was
> allocated for when it is created.
> 
> Signed-off-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.c | 2 +-
>   drivers/scsi/be2iscsi/be_iscsi.c         | 2 +-
>   drivers/scsi/bnx2i/bnx2i_iscsi.c         | 2 +-
>   drivers/scsi/cxgbi/libcxgbi.c            | 2 +-
>   drivers/scsi/qedi/qedi_iscsi.c           | 2 +-
>   drivers/scsi/qla4xxx/ql4_os.c            | 2 +-
>   drivers/scsi/scsi_transport_iscsi.c      | 3 ++-
>   include/scsi/scsi_transport_iscsi.h      | 6 +++++-
>   8 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 620ae5b2d80d..d38c909b462f 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -802,7 +802,7 @@ static struct iscsi_endpoint *iscsi_iser_ep_connect(struct Scsi_Host *shost,
>   	struct iser_conn *iser_conn;
>   	struct iscsi_endpoint *ep;
>   
> -	ep = iscsi_create_endpoint(0);
> +	ep = iscsi_create_endpoint(shost, 0);
>   	if (!ep)
>   		return ERR_PTR(-ENOMEM);
>   
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
> index 8aeaddc93b16..c893d193f5ef 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -1168,7 +1168,7 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
>   		return ERR_PTR(ret);
>   	}
>   
> -	ep = iscsi_create_endpoint(sizeof(struct beiscsi_endpoint));
> +	ep = iscsi_create_endpoint(shost, sizeof(struct beiscsi_endpoint));
>   	if (!ep) {
>   		ret = -ENOMEM;
>   		return ERR_PTR(ret);
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index a3c800e04a2e..ac63e93e07c6 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -384,7 +384,7 @@ static struct iscsi_endpoint *bnx2i_alloc_ep(struct bnx2i_hba *hba)
>   	struct bnx2i_endpoint *bnx2i_ep;
>   	u32 ec_div;
>   
> -	ep = iscsi_create_endpoint(sizeof(*bnx2i_ep));
> +	ep = iscsi_create_endpoint(hba->shost, sizeof(*bnx2i_ep));
>   	if (!ep) {
>   		printk(KERN_ERR "bnx2i: Could not allocate ep\n");
>   		return NULL;
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index af281e271f88..94edf8e1fb0c 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -2926,7 +2926,7 @@ struct iscsi_endpoint *cxgbi_ep_connect(struct Scsi_Host *shost,
>   		goto release_conn;
>   	}
>   
> -	ep = iscsi_create_endpoint(sizeof(*cep));
> +	ep = iscsi_create_endpoint(shost, sizeof(*cep));
>   	if (!ep) {
>   		err = -ENOMEM;
>   		pr_info("iscsi alloc ep, OOM.\n");
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
> index 31ec429104e2..4baf1dbb8e92 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -931,7 +931,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
>   		return ERR_PTR(-ENXIO);
>   	}
>   
> -	ep = iscsi_create_endpoint(sizeof(struct qedi_endpoint));
> +	ep = iscsi_create_endpoint(shost, sizeof(struct qedi_endpoint));
>   	if (!ep) {
>   		QEDI_ERR(&qedi->dbg_ctx, "endpoint create fail\n");
>   		ret = -ENOMEM;
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 005502125b27..acebf9c92c04 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -1717,7 +1717,7 @@ qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
>   	}
>   
>   	ha = iscsi_host_priv(shost);
> -	ep = iscsi_create_endpoint(sizeof(struct qla_endpoint));
> +	ep = iscsi_create_endpoint(shost, sizeof(struct qla_endpoint));
>   	if (!ep) {
>   		ret = -ENOMEM;
>   		return ERR_PTR(ret);
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index be69cea9c6f8..86bafdb862a5 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -204,7 +204,7 @@ static struct attribute_group iscsi_endpoint_group = {
>   };
>   
>   struct iscsi_endpoint *
> -iscsi_create_endpoint(int dd_size)
> +iscsi_create_endpoint(struct Scsi_Host *shost, int dd_size)
>   {
>   	struct iscsi_endpoint *ep;
>   	int err, id;
> @@ -230,6 +230,7 @@ iscsi_create_endpoint(int dd_size)
>   
>   	ep->id = id;
>   	ep->dev.class = &iscsi_endpoint_class;
> +	ep->dev.parent = &shost->shost_gendev;
>   	dev_set_name(&ep->dev, "ep-%d", id);
>   	err = device_register(&ep->dev);
>           if (err)

Umm... doesn't this change the sysfs layout?
IE won't the endpoint node be moved under the Scsi_Host directory?

But even if it does: do we care?


Cheers,

Hannes

