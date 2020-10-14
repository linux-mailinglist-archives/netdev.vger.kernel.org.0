Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59EB28D86B
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 04:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgJNCVw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Oct 2020 22:21:52 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:51866 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgJNCVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 22:21:52 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.69 with qID 09E2LJQ50027098, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb01.realtek.com.tw[172.21.6.94])
        by rtits2.realtek.com.tw (8.15.2/2.66/5.86) with ESMTPS id 09E2LJQ50027098
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Oct 2020 10:21:19 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Wed, 14 Oct 2020 10:21:19 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa]) by
 RTEXMB04.realtek.com.tw ([fe80::89f7:e6c3:b043:15fa%3]) with mapi id
 15.01.2044.006; Wed, 14 Oct 2020 10:21:19 +0800
From:   Andy Huang <tehuang@realtek.com>
To:     "'Nathan Chancellor'" <natechancellor@gmail.com>,
        "trix@redhat.com" <trix@redhat.com>
CC:     Tony Chuang <yhchuang@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: RE: [PATCH] rtw88: fix fw_fifo_addr check
Thread-Topic: [PATCH] rtw88: fix fw_fifo_addr check
Thread-Index: AQHWn+b1N2QCxO5tOEqVUSS+vGIPsamSt7QAgAOoEfA=
Date:   Wed, 14 Oct 2020 02:21:18 +0000
Message-ID: <ca5131599d3940d8a914025821876219@realtek.com>
References: <20201011155438.15892-1-trix@redhat.com>
 <20201012022428.GA936980@ubuntu-m3-large-x86>
In-Reply-To: <20201012022428.GA936980@ubuntu-m3-large-x86>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.231]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Sun, Oct 11, 2020 at 08:54:38AM -0700, trix@redhat.com wrote:
> > From: Tom Rix <trix@redhat.com>
> >
> > The clang build reports this warning
> >
> > fw.c:1485:21: warning: address of array 'rtwdev->chip->fw_fifo_addr'
> >   will always evaluate to 'true'
> >         if (!rtwdev->chip->fw_fifo_addr) {
> >
> > fw_fifo_addr is an array in rtw_chip_info so it is always nonzero.  A
> > better check is if the first element of the array is nonzero.  In the
> > cases where fw_fifo_addr is initialized by rtw88b and rtw88c, the
> > first array element is 0x780.
> >
> > Signed-off-by: Tom Rix <trix@redhat.com>
> 
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> 

Thanks for your fix,

Acked-by: Tzu-En Huang <tehuang@realtek.com>

> > ---
> >  drivers/net/wireless/realtek/rtw88/fw.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/realtek/rtw88/fw.c
> > b/drivers/net/wireless/realtek/rtw88/fw.c
> > index 042015bc8055..b2fd87834f23 100644
> > --- a/drivers/net/wireless/realtek/rtw88/fw.c
> > +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> > @@ -1482,7 +1482,7 @@ static bool rtw_fw_dump_check_size(struct
> > rtw_dev *rtwdev,  int rtw_fw_dump_fifo(struct rtw_dev *rtwdev, u8
> fifo_sel, u32 addr, u32 size,
> >  		     u32 *buffer)
> >  {
> > -	if (!rtwdev->chip->fw_fifo_addr) {
> > +	if (!rtwdev->chip->fw_fifo_addr[0]) {
> >  		rtw_dbg(rtwdev, RTW_DBG_FW, "chip not support dump fw fifo\n");
> >  		return -ENOTSUPP;
> >  	}
> > --
> > 2.18.1
> >
> 
> ------Please consider the environment before printing this e-mail.
