Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA981D8B6A
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgERXFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:05:42 -0400
Received: from novek.ru ([213.148.174.62]:50826 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgERXFm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 19:05:42 -0400
Received: from [10.0.1.119] (unknown [62.76.204.32])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id C0A6B5020BC;
        Tue, 19 May 2020 02:05:34 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru C0A6B5020BC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589843139; bh=sXrnJoqGvZtS/u8svJdsytuRkL+f1Auteww9XkOUGBw=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=qSW0lwskB2bYRHL66PbrmhLhxfbx99jxp550JRfBQFedoV1K6Cw/EZUiPayii9K8M
         mBphfVNBmbmxej/txx/3JP4tMGa1QNqlTFCaiHo8xBcHGomIDWW1KgVsf1nBQdmyxJ
         WjA4TvLJoDUA5FaeVjcUY4xFPtftHSCxic0YV9wg=
Subject: Re: [PATCH] net/tls: fix encryption error checking
To:     Jakub Kicinski <kuba@kernel.org>
References: <20200517014451.954F05026DE@novek.ru>
 <20200518153005.577dfe99@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANN+EMpn2ZkquAdK5WFC-bmioSoAbAtNvovXtgTyTHW+-eDPhw@mail.gmail.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <e26b157f-edc4-4a04-11ac-21485ed52f8a@novek.ru>
Date:   Tue, 19 May 2020 02:05:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CANN+EMpn2ZkquAdK5WFC-bmioSoAbAtNvovXtgTyTHW+-eDPhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=2.2 required=5.0 tests=RDNS_NONE,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.1
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19.05.2020 01:30, Jakub Kicinski wrote:
> > tls_push_record can return -EAGAIN because of tcp layer. In that
> > case open_rec is already in the tx_record list and should not be
> > freed.
> > Also the record size can be more than the size requested to write
> > in tls_sw_do_sendpage(). That leads to overflow of copied variable
> > and wrong return code.
> >
> > Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
> > Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
>
> Doesn't this return -EAGAIN back to user space? Meaning even tho we
> queued the user space will try to send it again?
Before patch it was sending negative value back to user space.
After patch it sends the amount of data encrypted in last call. It is checked
by:
  return (copied > 0) ? copied : ret;
and returns -EAGAIN only if data is not sent to open record.
