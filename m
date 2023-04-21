Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7846EAB43
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 15:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjDUNLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 09:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjDUNLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 09:11:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92E5D309
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 06:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682082603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8k2rgBBf1YF+OI88eA6xL7ypQDR8n8grAN8nTHY+8IU=;
        b=W4FA8V5YLGxezleukF+Huvjt0fhNAf4Ms2Xtxk0Ln9p8DuYb0kM5Onur6fzDL96WAXIouw
        mR5HdHzdh8OvFoFhqdlxeNlyhW3usHEetsUwm400HT/PSoeLHNMlz6XboERPLuK7ikk/7N
        FQlL+nRzGyvWRdBcLxUhpNqME1sxo6w=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-0j_ckUVuPdOuHH9YcBGaeA-1; Fri, 21 Apr 2023 09:10:02 -0400
X-MC-Unique: 0j_ckUVuPdOuHH9YcBGaeA-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-54fbf53aa09so1696907b3.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 06:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682082601; x=1684674601;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8k2rgBBf1YF+OI88eA6xL7ypQDR8n8grAN8nTHY+8IU=;
        b=IvNB/xtnIdHtCPrBXGa0SXrbemozImdVwXWG8Xn/3hmM9aRgE0Xbdx+KZ1EzzYVRFq
         KgKamBjfbb3OhdsT1vgrn5FlTNBEgFR9grz2Wf8Bli0lD1AszNUMll3JM79WW1ob0W1L
         k6t+7Yn5ZJOzkgMnRPyp9zUeWMbjqEHafMf1DvOWX2hqYW0uhzzPzG/uRZ83v1UZUPTq
         uPB5EwyQTqm2loWuUcQgjBw24PobmVgHFY3g6/VqE1+1lr0S7AlUszHBbnq8zLzTA2zm
         Xs1BdcWCdsmjcX61IK5PoSm2BMxIoTM/hjdJYfbefwPggHkFpPTjyucTZ+Uf5JWHeIfH
         NE/g==
X-Gm-Message-State: AAQBX9cVnWkZmPOfdNnElScGfcPhyjpM64+CKzZ2AJN5712Zu+Ypbjhj
        +kfY17E2Q+Q+Iyz1YKF4F3/LSSRJVpBMZHPO1wg00Zp1iyqsbOgiouEN83ro5F3oEaXLLZDd67u
        sxJZAqejj3s/saWPDok3cG55Q
X-Received: by 2002:a81:7895:0:b0:54f:8562:e36 with SMTP id t143-20020a817895000000b0054f85620e36mr3442951ywc.1.1682082601469;
        Fri, 21 Apr 2023 06:10:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZI9exIBD0b/4P9JGwKmvfDkmUctco3MmJPz2tq/9mZCEg1R/oiyVCQZ5Atosl/IXgJjz9v9Q==
X-Received: by 2002:a81:7895:0:b0:54f:8562:e36 with SMTP id t143-20020a817895000000b0054f85620e36mr3442920ywc.1.1682082601133;
        Fri, 21 Apr 2023 06:10:01 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-230-170.dyn.eolo.it. [146.241.230.170])
        by smtp.gmail.com with ESMTPSA id y18-20020a05620a09d200b0074bcf3ac7casm1309076qky.44.2023.04.21.06.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 06:10:00 -0700 (PDT)
Message-ID: <d84e9f5056c4945cb4cfcc68c89986d3094b95b7.camel@redhat.com>
Subject: Re: [PATCH net-next 5/5] net: optimize napi_threaded_poll() vs
 RPS/RFS
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Date:   Fri, 21 Apr 2023 15:09:58 +0200
In-Reply-To: <20230421094357.1693410-6-edumazet@google.com>
References: <20230421094357.1693410-1-edumazet@google.com>
         <20230421094357.1693410-6-edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

thank you for the extremely fast turnaround!

On Fri, 2023-04-21 at 09:43 +0000, Eric Dumazet wrote:
> We use napi_threaded_poll() in order to reduce our softirq dependency.
>=20
> We can add a followup of 821eba962d95 ("net: optimize napi_schedule_rps()=
")
> to further remove the need of firing NET_RX_SOFTIRQ whenever
> RPS/RFS are used.
>=20
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/linux/netdevice.h |  3 +++
>  net/core/dev.c            | 12 ++++++++++--
>  2 files changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index a6a3e9457d6cbc9fcbbde96b43b4b21878495403..08fbd4622ccf731daaee34ad9=
9773d6dc2e82fa6 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3194,7 +3194,10 @@ struct softnet_data {
>  #ifdef CONFIG_RPS
>  	struct softnet_data	*rps_ipi_list;
>  #endif
> +
>  	bool			in_net_rx_action;
> +	bool			in_napi_threaded_poll;

If I'm correct only one of the above 2 flags can be set to true at any
give time. I'm wondering if could use a single flag (possibly with a
rename - say 'in_napi_polling')?

Otherwise LGTM, many thanks!

Paolo

