Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BFE6EBF14
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 13:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjDWLJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 07:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDWLJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 07:09:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE6D10C6
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 04:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682248112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YJ86ZVDYRM9CotkEiqPEtZYHk4qaL2Mn/oKfEYumLFI=;
        b=f5SAWhttc4AiAw759Ji7WL4BpPSZ7VbyQfikV3oYvT3O1euRyjVpZReRgpa5K2vIyk9h17
        9m5KIC4UOF7qCzjE/eqXcC6EJJzeTQlddoL0JJGQ5s+iBSwaRUCciYRtojIvHw+4cgDErv
        f8BZoIrYHwUM6SKFAdEDa2isDKQ3SGU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-331-I41Q3m2XNv2kQ1GwBn95fw-1; Sun, 23 Apr 2023 07:08:31 -0400
X-MC-Unique: I41Q3m2XNv2kQ1GwBn95fw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f080f53d62so11235425e9.0
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 04:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682248110; x=1684840110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJ86ZVDYRM9CotkEiqPEtZYHk4qaL2Mn/oKfEYumLFI=;
        b=d9fHC24v62jFPx29Vj0WTtpGOw1FdqPiIkqfGYmCWRF7xNUne5RZ/CgGOaRgWF6AlA
         K73m4G9FIEw3B9i69nsfuSr+cD5TM+CGKue3+n95ygGjNfKaf3yuOck3BQGn0Ze96xhh
         zLSSd81qWQlqI1U6UaKE5BQ+yG/7z+kkELGWZsnnzUEcTHrg32qUzlqh7Vz8GHxNt2vs
         lgnvB5MLLhgSekncX6r2fkuPsoM5tyoyGiJ2L16rEaLcNGKD4xjXJ0nAheaKO91J3Y7H
         sDbfb/uJgXIeFuBLPBvezCNwVlym5xwklcRm8kLGl7q04PZQ3PCSo/pCw+Y8c3jk+osb
         /FYw==
X-Gm-Message-State: AAQBX9f6o4kIs1RLGIYN8Gh8s3jFtB/qF5inMINlJQbDuYy8jn5BTl9c
        NfG4O5IpH6FaEZ3iXwItrC9W0FJuiZ7/koiSqasBEySRsUUUu6Kpz0TZNmILWfwoQwttC0G1a7Q
        XpoEoPLjYnLuuP4qz
X-Received: by 2002:a7b:c393:0:b0:3f1:6458:99a7 with SMTP id s19-20020a7bc393000000b003f1645899a7mr5314659wmj.38.1682248109913;
        Sun, 23 Apr 2023 04:08:29 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z/eTtNo8BI6gHMtlywU6k2jFJAtKMz2XjK/PppbaZmNDeKGTzU6hmsHxo9LguBSKtEf649Aw==
X-Received: by 2002:a7b:c393:0:b0:3f1:6458:99a7 with SMTP id s19-20020a7bc393000000b003f1645899a7mr5314651wmj.38.1682248109608;
        Sun, 23 Apr 2023 04:08:29 -0700 (PDT)
Received: from redhat.com ([2.55.61.39])
        by smtp.gmail.com with ESMTPSA id k36-20020a05600c1ca400b003f1733feb3dsm12878417wms.0.2023.04.23.04.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 04:08:29 -0700 (PDT)
Date:   Sun, 23 Apr 2023 07:08:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Message-ID: <20230423070705-mutt-send-email-mst@kernel.org>
References: <20230417030713-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723F3E6AE381AEC36D1AEFED49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417051816-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237705695AFD873DEE4530D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417073830-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA4F0FFEBD25903E3344D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417075645-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA90465186B5A8A5C001D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423031308-mutt-send-email-mst@kernel.org>
 <AM0PR04MB472392318BC9A36CBA7AF19AD4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB472392318BC9A36CBA7AF19AD4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 08:01:35AM +0000, Alvaro Karsz wrote:
> We could add a new virtio_config_ops: peek_vqs.
> We can call it during virtnet_validate, and then fixup the features in case of small vrings.
> 
> If peek_vqs is not implemented by the transport, we can just fail probe later in case of small vrings.
> 

Nope, we can't. Driver is not supposed to discover vqs before
FEATURES_OK, the vq size might depend on features.

