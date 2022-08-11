Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA0B58F90C
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 10:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbiHKI2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 04:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbiHKI2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 04:28:20 -0400
Received: from louie.mork.no (louie.mork.no [IPv6:2001:41c8:51:8a:feff:ff:fe00:e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF429083A;
        Thu, 11 Aug 2022 01:28:15 -0700 (PDT)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9d:7e00:0:0:0:1])
        (authenticated bits=0)
        by louie.mork.no (8.15.2/8.15.2) with ESMTPSA id 27B8RhGh635424
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 09:27:44 +0100
Received: from miraculix.mork.no ([IPv6:2a01:799:961:910a:a293:6d6e:8bbf:c204])
        (authenticated bits=0)
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPSA id 27B8RbPu798373
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 10:27:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1660206458; bh=DVAcRpjHUD6SC/z94VyNoM8QbNmGcb9r0L8yrNq9za8=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=IqfPse84meJiD6rat7y8q0Fvr5+4dM8VBVy0T6cEFEIf/vQLJTozD8GEFESt9wR25
         w/zhVGfWNLne5aPP0/TFdP/MI/wUnuyQN2zyGrACzZfdrZo2JaxhakQvwLyY0xkS/1
         FU5GEkNh9NWjfvU36NsfGl318FOklJkjFcrqoFu0=
Received: (nullmailer pid 510642 invoked by uid 1000);
        Thu, 11 Aug 2022 08:27:32 -0000
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Slark Xiao <slark_xiao@163.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: qmi_wwan: Add support for Cinterion MV32
Organization: m
References: <20220810014521.9383-1-slark_xiao@163.com>
Date:   Thu, 11 Aug 2022 10:27:32 +0200
In-Reply-To: <20220810014521.9383-1-slark_xiao@163.com> (Slark Xiao's message
        of "Wed, 10 Aug 2022 09:45:21 +0800")
Message-ID: <87y1vvjibv.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.6 at canardo
X-Virus-Status: Clean
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Slark Xiao <slark_xiao@163.com> writes:

> There are 2 models for MV32 serials. MV32-W-A is designed
> based on Qualcomm SDX62 chip, and MV32-W-B is designed based
> on Qualcomm SDX65 chip. So we use 2 different PID to separate it.
>
> Test evidence as below:
> T:  Bus=3D03 Lev=3D01 Prnt=3D01 Port=3D02 Cnt=3D03 Dev#=3D  3 Spd=3D480 M=
xCh=3D 0
> D:  Ver=3D 2.10 Cls=3Def(misc ) Sub=3D02 Prot=3D01 MxPS=3D64 #Cfgs=3D  1
> P:  Vendor=3D1e2d ProdID=3D00f3 Rev=3D05.04
> S:  Manufacturer=3DCinterion
> S:  Product=3DCinterion PID 0x00F3 USB Mobile Broadband
> S:  SerialNumber=3Dd7b4be8d
> C:  #Ifs=3D 4 Cfg#=3D 1 Atr=3Da0 MxPwr=3D500mA
> I:  If#=3D0x0 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3D50 Drive=
r=3Dqmi_wwan
> I:  If#=3D0x1 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3D40 Drive=
r=3Doption
> I:  If#=3D0x2 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3D40 Drive=
r=3Doption
> I:  If#=3D0x3 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3D30 Drive=
r=3Doption
>
> T:  Bus=3D03 Lev=3D01 Prnt=3D01 Port=3D02 Cnt=3D03 Dev#=3D 10 Spd=3D480 M=
xCh=3D 0
> D:  Ver=3D 2.10 Cls=3Def(misc ) Sub=3D02 Prot=3D01 MxPS=3D64 #Cfgs=3D  1
> P:  Vendor=3D1e2d ProdID=3D00f4 Rev=3D05.04
> S:  Manufacturer=3DCinterion
> S:  Product=3DCinterion PID 0x00F4 USB Mobile Broadband
> S:  SerialNumber=3Dd095087d
> C:  #Ifs=3D 4 Cfg#=3D 1 Atr=3Da0 MxPwr=3D500mA
> I:  If#=3D0x0 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3D50 Drive=
r=3Dqmi_wwan
> I:  If#=3D0x1 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3D40 Drive=
r=3Doption
> I:  If#=3D0x2 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3D40 Drive=
r=3Doption
> I:  If#=3D0x3 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3D30 Drive=
r=3Doption
>
> Signed-off-by: Slark Xiao <slark_xiao@163.com>

Thanks for answering all my questions so fast. This patch looks very
good to me

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>

