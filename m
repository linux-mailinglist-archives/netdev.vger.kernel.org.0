Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA93168D72D
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 13:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbjBGMtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 07:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjBGMtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 07:49:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0929E14485
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 04:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675774103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3pNnVVvvF8/Ot6Ip5i4hvaULShyHI18MUkSy36eZSxE=;
        b=YS6HOubElUaqNqip3S5OwnrNYs15OQHaPqLZvj15+XkAblHRIRaYprtRrIL8u32z6u/M+v
        QStWO8oU0qKJS161LrTawH2uRxZ0oYycBH+KvXra3e9jTl8RHTEtlKDtKEGpQzb0DB+kqr
        BVNv2k3+Nc+pBz1nN+s6RzTkj7VJqPI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-131-Z6q7ncf4NBaSJFCF-E8GCQ-1; Tue, 07 Feb 2023 07:48:22 -0500
X-MC-Unique: Z6q7ncf4NBaSJFCF-E8GCQ-1
Received: by mail-qv1-f70.google.com with SMTP id ks3-20020a056214310300b0056bec2871e8so3615550qvb.1
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 04:48:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3pNnVVvvF8/Ot6Ip5i4hvaULShyHI18MUkSy36eZSxE=;
        b=j/5o2v7Q+/KGtr2r+hYujF6kCFHfp7uKoZ/8rvXHN2Mzt/trstNo/jtJ0mqvBHn9wV
         yezGXq77d35fKp5Xvwber8YPHi0L3tZ07Gss8p0E4yLTrh46+cW9OR2rZA/x27Oi1UEE
         I18VNFPi6epSU+DEiJ1bjTqRDHgk76tq5PA9j81AEWy6Tpv1u9sHbyV2ork4AsPfWCUu
         MxqKxq9GOnjFQ94aNrtK42QnwGTo3bLdnSMvqsskxkj/iVSJntV96htfKEgAG//3jQpS
         q2AhrY/ZXXH5qP1IXvS2NnAl4Ru0aZG9il5peGSv7CDvMV6f2S4C5S8Dos/x7tCmk8rK
         x2hA==
X-Gm-Message-State: AO0yUKWFtOXC6r5m7PIWLeCCcMddMas6ZzdsTU7Ahd6Pjf45JOpIO2rK
        3Fp5QqV9Dnw4G1wznbHt3fgns6BOv79WmADhZLXCA8zaVQGsIZbrJxW/gZhJPrcTfYWDI528X/I
        ZO2k2XfEILy6NTqQ4
X-Received: by 2002:a05:622a:4d2:b0:3b6:35cb:b944 with SMTP id q18-20020a05622a04d200b003b635cbb944mr6044721qtx.2.1675774101600;
        Tue, 07 Feb 2023 04:48:21 -0800 (PST)
X-Google-Smtp-Source: AK7set+mQoNSGATnBKIkXvsLl6p0m/4Ku460QBMKXR+jCVcof7QL6e4N6h/kUynB2ZQZ4hY6I+ltGg==
X-Received: by 2002:a05:622a:4d2:b0:3b6:35cb:b944 with SMTP id q18-20020a05622a04d200b003b635cbb944mr6044667qtx.2.1675774101255;
        Tue, 07 Feb 2023 04:48:21 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id f18-20020a05620a20d200b007090f7a4f2asm9344737qka.82.2023.02.07.04.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 04:48:20 -0800 (PST)
Message-ID: <b25f37e4e11d9da5b6d61cbfaa0cafe9889c3926.camel@redhat.com>
Subject: Re: [net-next PATCH V3 4/4] octeontx2-pf: Add support for HTB
 offload
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, saeedm@nvidia.com,
        richardcochran@gmail.com, tariqt@nvidia.com,
        linux-rdma@vger.kernel.org, maxtram95@gmail.com,
        naveenm@marvell.com, hariprasad.netdev@gmail.com
Date:   Tue, 07 Feb 2023 13:48:11 +0100
In-Reply-To: <20230206054640.5854-5-hkelam@marvell.com>
References: <20230206054640.5854-1-hkelam@marvell.com>
         <20230206054640.5854-5-hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-02-06 at 11:16 +0530, Hariprasad Kelam wrote:
> +static int otx2_qos_txschq_alloc(struct otx2_nic *pfvf,
> +				 struct otx2_qos_cfg *cfg)
> +{
> +	struct nix_txsch_alloc_req *req;
> +	struct nix_txsch_alloc_rsp *rsp;
> +	struct mbox *mbox =3D &pfvf->mbox;
> +	int lvl, rc, schq;
> +
> +	mutex_lock(&mbox->lock);
> +	req =3D otx2_mbox_alloc_msg_nix_txsch_alloc(&pfvf->mbox);
> +	if (!req)
> +		return -ENOMEM;

This does not releases the mbox->lock mutex on error (another
occurrence below).

[...]


> +static int otx2_qos_txschq_update_config(struct otx2_nic *pfvf,
> +					 struct otx2_qos_node *node,
> +					 struct otx2_qos_cfg *cfg)
> +{
> +	int ret =3D 0;
> +
> +	otx2_qos_txschq_fill_cfg(pfvf, node, cfg);
> +	ret =3D otx2_qos_txschq_push_cfg(pfvf, node, cfg);
> +
> +	return ret;

I personally find the plain:

	return <function>

more easy to read - more instances below.

[...]

> +static void otx2_reset_qdisc(struct net_device *dev, u16 qid)
> +{
> +	struct netdev_queue *dev_queue =3D netdev_get_tx_queue(dev, qid);
> +	struct Qdisc *qdisc =3D dev_queue->qdisc_sleeping;
> +
> +	if (!qdisc)
> +		return;
> +
> +	spin_lock_bh(qdisc_lock(qdisc));
> +	qdisc_reset(qdisc);
> +	spin_unlock_bh(qdisc_lock(qdisc));
> +}

The above looks like a possible shared helper, as mlx code implements a
quite identical function.

Cheers,

Paolo

