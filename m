Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840156F018C
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 09:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243002AbjD0HVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 03:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242691AbjD0HVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 03:21:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE9449EE
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 00:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682579969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cdXy2quNId8CK4ZHgOGhfxQrxC/+0UxDqjQ9Y9bXxL8=;
        b=GofTknCibrIVyLXzeKr3KTnmow0lfxSjH6z2pWBTlC/36e4uD2J18I+jaL2jUixpfmj4D1
        E1UmfwTLwWskkr2Fu4mo7kVzsCAQqabx+d9FUOTuXqkfpjm4ODpSzjp87qsbQUfpRZSJG8
        PsnGgob+TywxcZBYkLko+ko0OwbDz6k=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-DcClPypfO3ugTy9fq8q0vA-1; Thu, 27 Apr 2023 03:19:26 -0400
X-MC-Unique: DcClPypfO3ugTy9fq8q0vA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-94f734c6cf8so779735266b.3
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 00:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682579964; x=1685171964;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cdXy2quNId8CK4ZHgOGhfxQrxC/+0UxDqjQ9Y9bXxL8=;
        b=IjfesdGsdxAhriRglGJi8DQMVBeRRi4zAyKKNRCOizHmni14s1d44Q6c2327H1oA+Q
         5sBFY1bcdXJnmAVho7FYpRwI3JsZvuKHju+13Q6PdPR40VTl1XWZYlBhds3JrdHg0cCr
         /8VCQhrVPNIArtgcGQgbauVb+qoXnFyPxQJVbhF7bweZnfvKHCXWUIAwdxDuytUsBLVz
         al9zJQGmEfd3yStoMfUA8xMvx058hx1SGGhrs7uHUk7jjyCt5oKtlmkw7ctm02k53jvG
         Jsxk/9Lnfs8kATpATFqnZj/de4zq7MJKzzeIKVzzI5Ir9FGAZxAmgTVmI3UwKc98GbOR
         p2WA==
X-Gm-Message-State: AC+VfDxxgnsI75agvKAiIjuSMAefZZogUyJzQg0fYTdCohHFisQZ4Vpz
        7Iqu6xbz4wpeMjEVN/XLCIDBFUASbzPDHhZAvWnh325qVGqLaj3w+OSm5vq+O3fzal0ZOhoPnKp
        7au9ExjY9/Z6LoHCsdcN4HIFbU0VYZLDIlTCR1IxsLLM=
X-Received: by 2002:a17:906:6a28:b0:93c:efaf:ba75 with SMTP id qw40-20020a1709066a2800b0093cefafba75mr763036ejc.37.1682579964560;
        Thu, 27 Apr 2023 00:19:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6EF0PnAl6PdM3tEt2qgEPUoow7C+tT3biu8u/GY0uiflJKD0l3m/h8IBz2E1es/Lkumu7r5VvSR9MIswGVeiQ=
X-Received: by 2002:a17:906:6a28:b0:93c:efaf:ba75 with SMTP id
 qw40-20020a1709066a2800b0093cefafba75mr763019ejc.37.1682579964249; Thu, 27
 Apr 2023 00:19:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230427034343.1401883-1-liali@redhat.com> <13c54cd1-6fb7-b6b8-79a1-af0a95793700@blackwall.org>
In-Reply-To: <13c54cd1-6fb7-b6b8-79a1-af0a95793700@blackwall.org>
From:   Liang Li <liali@redhat.com>
Date:   Thu, 27 Apr 2023 15:19:13 +0800
Message-ID: <CAKVySpyXYUDUtA26pA7A0buCW30VNhgn7aYc+cTXbb9PK=F5oA@mail.gmail.com>
Subject: Re: [PATCH net] selftests: bonding: delete unnecessary line.
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com,
        Hangbin Liu <liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you! Do I need to re-send a patch?

Regards,
Liang Li

On Thu, Apr 27, 2023 at 2:53=E2=80=AFPM Nikolay Aleksandrov <razor@blackwal=
l.org> wrote:
>
> On 27/04/2023 06:43, Liang Li wrote:
> > "ip link set dev "$devbond1" nomaster"
> > This line code in bond-eth-type-change.sh is unnecessary.
> > Because $devbond1 was not added to any master device.
> >
> > Signed-off-by: Liang Li <liali@redhat.com>
> > Acked-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >  .../selftests/drivers/net/bonding/bond-eth-type-change.sh        | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/drivers/net/bonding/bond-eth-type-=
change.sh b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-chang=
e.sh
> > index 5cdd22048ba7..862e947e17c7 100755
> > --- a/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.=
sh
> > +++ b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.=
sh
> > @@ -53,7 +53,6 @@ bond_test_enslave_type_change()
> >       # restore ARPHRD_ETHER type by enslaving such device
> >       ip link set dev "$devbond2" master "$devbond0"
> >       check_err $? "could not enslave $devbond2 to $devbond0"
> > -     ip link set dev "$devbond1" nomaster
> >
> >       bond_check_flags "$devbond0"
> >
>
> I don't think this is -net material. But either way the patch looks good.
>

