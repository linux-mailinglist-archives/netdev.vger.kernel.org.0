Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D822C55A7E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfFYWCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:02:10 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46639 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfFYWCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:02:09 -0400
Received: by mail-ot1-f65.google.com with SMTP id z23so395760ote.13;
        Tue, 25 Jun 2019 15:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=igkkvlks/N9Xu/3ElACorM1gl26Qp7bOyyD3Y7hH+mg=;
        b=VJzs4P07GFzHn6ixVtGwgBo6xXidA4OL5rPeP1YBXvZN6zFfco2L7cUPbWNgZuh4/D
         9bkrhS26mSlXCtTSVNAFGJLSJJftRcP+Ytcq7rxBUA8yk0YJpas3eFASPqvmrtL+C1oy
         IMKBz9oOqsgmkbQAa39JbRkxg3fTcqWRdVWwahVrIm2vNboIdkE9qZFgmQSwA7waP+Lr
         VlMX2pOMewAQPZ2OdRRDtXg7NCzYQ9AG8WLkSPXkZclJZsvpj4ckJ6QFpAkBpeRcTPxt
         G2VdnngncgdicDhPLszo57WXOg68dKxqXPOcc4lXnJAWAsFdnbF9g1Nb16mXoURrFuK1
         p6NA==
X-Gm-Message-State: APjAAAU1mv8MFI2oh23ZxJgEaDjJicKeBrq1g5SVU1XGXFkt72bgrdZC
        fEITlhHZzzTCBqi7KKsFxUs=
X-Google-Smtp-Source: APXvYqxx3PrIlbaO0BcBlzk+2c9aab/cXr16Y8L/ky6kb98uqYnb2enhgU/rRJmwwCixNjpokQxo2A==
X-Received: by 2002:a9d:711e:: with SMTP id n30mr471265otj.97.1561500127605;
        Tue, 25 Jun 2019 15:02:07 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id n26sm5687184otq.10.2019.06.25.15.02.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 15:02:06 -0700 (PDT)
Subject: Re: [for-next V2 08/10] linux/dim: Implement rdma_dim
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-9-saeedm@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <bfa2159e-1576-6b3c-c85b-ee98bd4f9a47@grimberg.me>
Date:   Tue, 25 Jun 2019 15:02:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625205701.17849-9-saeedm@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> +void rdma_dim(struct dim *dim, u64 completions)
> +{
> +	struct dim_sample *curr_sample = &dim->measuring_sample;
> +	struct dim_stats curr_stats;
> +	u32 nevents;
> +
> +	dim_update_sample_with_comps(curr_sample->event_ctr + 1,
> +				     curr_sample->pkt_ctr,
> +				     curr_sample->byte_ctr,
> +				     curr_sample->comp_ctr + completions,
> +				     &dim->measuring_sample);

If this is the only caller, why add pkt_ctr and byte_ctr at all?
