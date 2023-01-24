Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83DB06796BF
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbjAXLfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233448AbjAXLfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:35:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8F14522B
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 03:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674560068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dIQjDqsp5sDFM3BVH/jSDJZM7jmKcynwfKM1PfNw7yg=;
        b=Yv2haaultroR9znbrJ6U/a+0q0CLlctM0YfNzuyKVrMUe5pHlCy6J9H00vHOZxfNl+OYRN
        p2nKYWONvwOpoiVL0k/Hq+PqzNv5H02N82TvNgxyaRznxayn8qUYSuwhVk8UuIBdUafaro
        ztvEUqFfIEfmflyxKvqa9ra9daCmAn4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-403-JwJE_xiJPW-6uObkYRIy4w-1; Tue, 24 Jan 2023 06:34:27 -0500
X-MC-Unique: JwJE_xiJPW-6uObkYRIy4w-1
Received: by mail-qk1-f198.google.com with SMTP id bm30-20020a05620a199e00b007090f3c5ec0so9087114qkb.21
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 03:34:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dIQjDqsp5sDFM3BVH/jSDJZM7jmKcynwfKM1PfNw7yg=;
        b=pmg1S1xemgPDu/XHdSlFATVIxPZ1YJrqEe3s7YrwFy2FXXg3cseVNDoQkAF1fHuOPQ
         6m1slzhHIZJGMrCr7KJ1EiDqaHgR2oCJZQOlv1vxQfMG4WwD2eNQ3xeCMa0JGAWbVzZT
         AHifSwXVI4RIoNsq/v/HwqkSwVxAHjQ2dNwP+HCw7T6RFAfp6u29qWRPLpmXXSbVUH8d
         YKns0v6quNqFk8J/y4pP3YrqMJ1v0aMsIeBtBgtwg4Y+qXDYi1LS1TN8U5Go2YTzucjX
         XibnnoZx3yfuOIUOX1UvRdsC7fY2ghtJZLBEFfphaM6OzeRxfIf2dDLWGZ1f8Ncdk/NU
         5NOQ==
X-Gm-Message-State: AFqh2kqp6q8+yOCwaMNKuno5iYq16tTHfZKPvBmvMdDvY+/4+ex9GZul
        kjBAyuULU2dlTVU3O4wqFBTMhR1YvOCdIspWZERfuGxB/cfAjY+gy0OhwI0lzzJWlqFjazyDCu4
        mq26HlkUQzpYu2KPC
X-Received: by 2002:ac8:7081:0:b0:3b6:3c7e:366e with SMTP id y1-20020ac87081000000b003b63c7e366emr40455595qto.14.1674560066659;
        Tue, 24 Jan 2023 03:34:26 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtnbaj5/dcwQTYKaB3E/uG1V9fjQWMRrv0kFBIrI2GQ3xbwdRWLjKscdn/TMemmfc+Q5bF+GQ==
X-Received: by 2002:ac8:7081:0:b0:3b6:3c7e:366e with SMTP id y1-20020ac87081000000b003b63c7e366emr40455572qto.14.1674560066366;
        Tue, 24 Jan 2023 03:34:26 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id ed3-20020a05620a490300b006faf76e7c9asm1225182qkb.115.2023.01.24.03.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 03:34:25 -0800 (PST)
Message-ID: <ddb7520869c8143ea6bf3fc99716e4369d2518db.camel@redhat.com>
Subject: Re: [PATCH net-next 1/2] ethtool: netlink: handle SET intro/outro
 in the common code
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, mkubecek@suse.cz
Date:   Tue, 24 Jan 2023 12:34:23 +0100
In-Reply-To: <20230121054430.642280-1-kuba@kernel.org>
References: <20230121054430.642280-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 2023-01-20 at 21:44 -0800, Jakub Kicinski wrote:
> diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
> index a8c113d244db..8e9aced3eeec 100644
> --- a/net/ethtool/pause.c
> +++ b/net/ethtool/pause.c
> @@ -114,18 +114,6 @@ static int pause_fill_reply(struct sk_buff *skb,
>  	return 0;
>  }
> =20
> -const struct ethnl_request_ops ethnl_pause_request_ops =3D {
> -	.request_cmd		=3D ETHTOOL_MSG_PAUSE_GET,
> -	.reply_cmd		=3D ETHTOOL_MSG_PAUSE_GET_REPLY,
> -	.hdr_attr		=3D ETHTOOL_A_PAUSE_HEADER,
> -	.req_info_size		=3D sizeof(struct pause_req_info),
> -	.reply_data_size	=3D sizeof(struct pause_reply_data),
> -
> -	.prepare_data		=3D pause_prepare_data,
> -	.reply_size		=3D pause_reply_size,
> -	.fill_reply		=3D pause_fill_reply,
> -};
> -
>  /* PAUSE_SET */
> =20
>  const struct nla_policy ethnl_pause_set_policy[] =3D {

This chunk does not apply cleanly due to commit 04692c9020b7 ("net:
ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)")

Could you please rebase?

Thanks!

Paolo

