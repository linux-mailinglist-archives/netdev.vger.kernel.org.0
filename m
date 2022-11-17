Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8F562DEF6
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239833AbiKQPER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbiKQPEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:04:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEF8748C9
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668697394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4kP3I1EFsocj5neBUfNHWwkMSIOfBtU0NTLvuRyv3+g=;
        b=epAVELbcKhypNQl4DRt9roWS18LR9SEP64+3pVWagzhqyvv0gN0g7GJtDStYyTfOqBHe8p
        xRkn9bbOSwKwh/jp0u3ABgLUWkCnulz3sg/x5A4hRVg3vsCRhcFUjkjs82hlJuXJKef4M6
        vkenEySS5o9Qljq/8ALOY6db4RB3aws=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-564-il7kNngmNuq2AjhzxnYIjw-1; Thu, 17 Nov 2022 10:03:13 -0500
X-MC-Unique: il7kNngmNuq2AjhzxnYIjw-1
Received: by mail-qk1-f200.google.com with SMTP id bi42-20020a05620a31aa00b006faaa1664b9so2370421qkb.8
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:03:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4kP3I1EFsocj5neBUfNHWwkMSIOfBtU0NTLvuRyv3+g=;
        b=7ks48n0sFAPFLiX4NIjIBs/DY6CouhOs8gNVI6hy7fo74D0wONbHpCwwLRomCrlT2l
         qn/kebVTHFBZhScnc8168Oy3m7YqpSAKsTR1JYh/YNebfPW6ZtASbvgVqSwZy/Tzl7/G
         0G/MNgSGUuIUPwCqRLzHP/a3MeC9IxBRmfczJUdEi8Gnd7u/nOxIr1hmEG9zKS3ikyEs
         I5Hvcse8Xgp1VJICgJIhIVS8MtFsYKEZg1fXzsf7bc+3BwP29VE+S+9VftK5fEp9NKR+
         LSgf0NzxKLZbhKCTNhek+7o4K2xl6gY0r+2436tyJnrJUi9qk2788eq5jAfJw6+/SGc9
         ap2g==
X-Gm-Message-State: ANoB5pkKtoT0Vv5VcgjKGVOlcejLJVFkeFhMWVrJ992sU7uTN3W3Tju5
        9eXqu4geg0cgmuA+ugeUij3OqRbjGxT6oI/6aWNdIc9PQ0U99wCMzO7Fg/fxpb/qKkQyyfGXK9h
        epsGZcbdk1Ma+QwUS
X-Received: by 2002:ae9:dec2:0:b0:6fa:1c6f:1674 with SMTP id s185-20020ae9dec2000000b006fa1c6f1674mr1957802qkf.219.1668697392571;
        Thu, 17 Nov 2022 07:03:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4ETfSrHfnC9NDbUvs1Ku+VUyCrRN60tL3WKkpDiJahvICyf3/cs/lgtM0qGX5O1Kk8IWsUhw==
X-Received: by 2002:ae9:dec2:0:b0:6fa:1c6f:1674 with SMTP id s185-20020ae9dec2000000b006fa1c6f1674mr1957782qkf.219.1668697392326;
        Thu, 17 Nov 2022 07:03:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id fd3-20020a05622a4d0300b003a586888a20sm472747qtb.79.2022.11.17.07.03.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 07:03:11 -0800 (PST)
Message-ID: <519cbacf20b10909ee362e0bcc9aa87cbb7137f3.camel@redhat.com>
Subject: Re: [PATCH net-next] net: microchip: sparx5: prevent uninitialized
 variable
From:   Paolo Abeni <pabeni@redhat.com>
To:     Dan Carpenter <error27@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Machon <daniel.machon@microchip.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date:   Thu, 17 Nov 2022 16:03:07 +0100
In-Reply-To: <Y3OQrGoFqvX2GkbJ@kili>
References: <Y3OQrGoFqvX2GkbJ@kili>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-11-15 at 16:14 +0300, Dan Carpenter wrote:
> Smatch complains that:
> 
>     drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c:112
>     sparx5_dcb_apptrust_validate() error: uninitialized symbol 'match'.
> 
> This would only happen if the:
> 
> 	if (sparx5_dcb_apptrust_policies[i].nselectors != nselectors)
> 
> condition is always true (they are not equal).  The "nselectors"
> variable comes from dcbnl_ieee_set() and it is a number between 0-256.
> This seems like a probably a real bug.
> 
> Fixes: 23f8382cd95d ("net: microchip: sparx5: add support for apptrust")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

checkpatch complains about the From/SoB mismatch - 
'Dan Carpenter <error27@gmail.com>' vs 'Dan Carpenter
<dan.carpenter@oracle.com>'

Could you please send a v2 addressing that?

thanks!

Paolo


