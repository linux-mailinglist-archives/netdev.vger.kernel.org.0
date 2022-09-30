Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5AB5F0247
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 03:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiI3Bfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 21:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiI3Bfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 21:35:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A313315313C;
        Thu, 29 Sep 2022 18:35:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E11ECB826E8;
        Fri, 30 Sep 2022 01:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F302DC433D6;
        Fri, 30 Sep 2022 01:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664501747;
        bh=0fg56xsNkyUIp38+qfMscFrTPpgIj1Qpmoa/DrZBQ10=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SsQysmbRk6FLwOwp5bSgqhB4o+vgT4ag8EwgwsBAHjBE/SOnzJUyNnsZHGjCeATLs
         ZNm3CbczLYYCbbFBaPYmXmMipy0ggmKwW27W9EZdmxdCyYwjxIfzwm93qsg6yUImMH
         86UvHT08drHLTsDd2n+RfADDWxIHmB9aRQfBRpuB4xT4ZGQg40VBz94Rk+QF8mMRHY
         Z1IEJc7p4xjheAEwanBpnEzla/pwLkfKbSu8LhbxNfT+dOdvAO5+O5k1SSwB5DWdvG
         88DJuEfZsoPvM/GvHqb2dv1m+7I5038K32M7uR5rG0dhS3W+tEq5hOwFzjJ5CCS8jk
         VQTPacy7fUGTg==
Date:   Thu, 29 Sep 2022 18:35:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Junichi Uekawa (=?UTF-8?B?5LiK5bed57SU5LiA?=) " 
        <uekawa@chromium.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Message-ID: <20220929183545.6ff5048a@kernel.org>
In-Reply-To: <CADgJSGGNjsnmzVdHkhqDN+_1cJxcPYe-U=a4A4TAL8PA6=owCw@mail.gmail.com>
References: <20220928064538.667678-1-uekawa@chromium.org>
        <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
        <20220928052738-mutt-send-email-mst@kernel.org>
        <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
        <CADgJSGHxPWXJjbakEeWnqF42A03yK7Dpw6U1SKNLhk+B248Ymg@mail.gmail.com>
        <20220929031419-mutt-send-email-mst@kernel.org>
        <20220929074606.yqzihpcc7cl442c5@sgarzare-redhat>
        <20220929034807-mutt-send-email-mst@kernel.org>
        <20220929090731.27cda58c@kernel.org>
        <20220929122444-mutt-send-email-mst@kernel.org>
        <20220929110740.77942060@kernel.org>
        <CADgJSGGNjsnmzVdHkhqDN+_1cJxcPYe-U=a4A4TAL8PA6=owCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sep 2022 09:49:54 +0900 Junichi Uekawa (=E4=B8=8A=E5=B7=9D=E7=B4=
=94=E4=B8=80) wrote:
> > > I think they want it in 6.0 as it fixes a crash. =20
> >
> > I thought it's just an OOM leading to send failure. Junichi could you
> > repost with the tags collected and the header for that stack trace
> > included? The line that says it's just an OOM...
> > =20
>=20
> I think this is what you asked for but I don't quite know what you
> mean by the tags

We call Reviewed-by: Acked-by: Fixes: etc trailers "tags".
Don't worry tho, you shared the full stack trace now, I'll
fix the message up when applying.
