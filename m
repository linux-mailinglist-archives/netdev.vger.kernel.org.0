Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352496C754A
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 03:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbjCXCCZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Mar 2023 22:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCXCCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 22:02:24 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44B618B1C
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 19:02:20 -0700 (PDT)
X-QQ-mid: Yeas50t1679623317t010t00979
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FL9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
To:     <Steen.Hegelund@microchip.com>, <netdev@vger.kernel.org>
Cc:     <mengyuanlou@net-swift.com>
References: <20230322103632.132011-1-jiawenwu@trustnetic.com> <CRDPDHCPMF0Y.2F1OU3EK4P9NI@den-dk-m31857>
In-Reply-To: <CRDPDHCPMF0Y.2F1OU3EK4P9NI@den-dk-m31857>
Subject: RE: [PATCH net] net: wangxun: Fix vector length of interrupt cause
Date:   Fri, 24 Mar 2023 10:01:55 +0800
Message-ID: <01b501d95df4$9c4262a0$d4c727e0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQGBzpAOldIMecGWDQx0/IE7i8VtowLse1msr6DjeVA=
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.0 required=5.0 tests=FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, March 23, 2023 6:50 PM, Steen.Hegelund@microchip.com wrote:
> 
> Hi Jiawen,
> 
> 
> On Wed Mar 22, 2023 at 11:36 AM CET, Jiawen Wu wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know
> > the content is safe
> >
> > There is 64-bit interrupt cause register for txgbe. Fix to clear upper
> > 32 bits.
> >
> > Fixes: 3f703186113f ("net: libwx: Add irq flow functions")
> > Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> > ---
> >  drivers/net/ethernet/wangxun/libwx/wx_type.h    | 2 +-
> >  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c   | 2 +-
> >  drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 3 ++-
> >  3 files changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h
> > b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> > index 77d8d7f1707e..97e2c1e13b80 100644
> > --- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
> > +++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> > @@ -222,7 +222,7 @@
> >  #define WX_PX_INTA                   0x110
> >  #define WX_PX_GPIE                   0x118
> >  #define WX_PX_GPIE_MODEL             BIT(0)
> > -#define WX_PX_IC                     0x120
> > +#define WX_PX_IC(_i)                 (0x120 + (_i) * 4)
> >  #define WX_PX_IMS(_i)                (0x140 + (_i) * 4)
> >  #define WX_PX_IMC(_i)                (0x150 + (_i) * 4)
> >  #define WX_PX_ISB_ADDR_L             0x160
> > diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> > b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> > index 5b564d348c09..17412e5282de 100644
> > --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> > +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> > @@ -352,7 +352,7 @@ static void ngbe_up(struct wx *wx)
> >         netif_tx_start_all_queues(wx->netdev);
> >
> >         /* clear any pending interrupts, may auto mask */
> > -       rd32(wx, WX_PX_IC);
> > +       rd32(wx, WX_PX_IC(0));
> 
> Here you only clear irq 0 but not 1...
> 
> >         rd32(wx, WX_PX_MISC_IC);
> >         ngbe_irq_enable(wx, true);
> >         if (wx->gpio_ctrl)
> > diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> > b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> > index 6c0a98230557..a58ce5463686 100644
> > --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> > +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> > @@ -229,7 +229,8 @@ static void txgbe_up_complete(struct wx *wx)
> >         wx_napi_enable_all(wx);
> >
> >         /* clear any pending interrupts, may auto mask */
> > -       rd32(wx, WX_PX_IC);
> > +       rd32(wx, WX_PX_IC(0));
> > +       rd32(wx, WX_PX_IC(1));
> 
> Here you clear irq 0 and 1
> 
> >         rd32(wx, WX_PX_MISC_IC);
> >         txgbe_irq_enable(wx, true);
> >
> > --
> > 2.27.0
> 
> Why is there a difference between the two situations?
> 
> BR
> Steen

There is two different chip with different hardware design.
The register WX_PX_IC has total 64 bits in its low and high registers, which names WX_PX_IC(0) and WX_PX_IC(1).
For txgbe, it's necessary to clear irq 0-63, but 0-8 for ngbe.


