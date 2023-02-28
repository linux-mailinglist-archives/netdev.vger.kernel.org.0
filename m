Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E666A586A
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 12:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjB1LhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 06:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjB1LhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 06:37:03 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EE76198;
        Tue, 28 Feb 2023 03:37:01 -0800 (PST)
Received: from fpc (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 1A4B14076277;
        Tue, 28 Feb 2023 11:25:36 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 1A4B14076277
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1677583536;
        bh=dseDSkkDHilrS59Zk+KH9sYISD8C5wKWpJzIj3wjll8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MiTjTGrbn73mC02flyHmmxWFWNNvXwDe0yrK8lTSI8BoWShr1298JbU6Z5UHPouDx
         IwsYwh3gS2jUqD15v/tSDPM6PjbVY+8nT8Tj0U0kkMgU+ompnzTvgQH8/Meya7NjtQ
         75TO2dEq3sTqMyxGHpFJo9GP2tw5AUbTQL4OrEBA=
Date:   Tue, 28 Feb 2023 14:25:31 +0300
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guenter Roeck <groeck@google.com>,
        Martin Faltesek <mfaltesek@google.com>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Samuel Ortiz <sameo@linux.intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com
Subject: Re: [PATCH] nfc: fix memory leak of se_io context in nfc_genl_se_io
Message-ID: <20230228112531.gam3dwqyx36pyynf@fpc>
References: <20230225105614.379382-1-pchelkin@ispras.ru>
 <b0f65aaa-37aa-378f-fbbf-57d107f29f5f@linaro.org>
 <20230227150553.m3okhdxqmjgon4dd@fpc>
 <7e9ffa10-d6e8-48b5-e832-cf77ac1a8802@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e9ffa10-d6e8-48b5-e832-cf77ac1a8802@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 11:14:03AM +0100, Krzysztof Kozlowski wrote:
> On 27/02/2023 16:05, Fedor Pchelkin wrote:
> >>> Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
> >>> Reported-by: syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com
> >>> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> >>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> >>
> >> SoB order is a bit odd. Who is the author?
> >>
> > 
> > The author is me (Fedor). I thought the authorship is expressed with the
> > first Signed-off-by line, isn't it?
> 
> Yes and since you are sending it, then what is Alexey's Sob for? The
> tags are in order...
> 

Now I get what you mean. Alexey is my supervisor and the patches I make
are passed through him (even though they are sent by me). If this is not
a customary thing, then I'll take that into account for further
submissions. I guess something like Acked-by is more appropriate?

> > 
> >>> ---
> >>>  drivers/nfc/st-nci/se.c   | 6 ++++++
> >>>  drivers/nfc/st21nfca/se.c | 6 ++++++
> >>>  net/nfc/netlink.c         | 4 ++++
> >>>  3 files changed, 16 insertions(+)
> >>>
> >>> diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
> >>> index ec87dd21e054..b2f1ced8e6dd 100644
> >>> --- a/drivers/nfc/st-nci/se.c
> >>> +++ b/drivers/nfc/st-nci/se.c
> >>> @@ -672,6 +672,12 @@ int st_nci_se_io(struct nci_dev *ndev, u32 se_idx,
> >>>  					ST_NCI_EVT_TRANSMIT_DATA, apdu,
> >>>  					apdu_length)
> >> nci_hci_send_event() should also free it in its error paths.
> >> nci_data_exchange_complete() as well? Who eventually frees it? These
> >> might be separate patches.
> >>
> >>
> > 
> > nci_hci_send_event(), as I can see, should not free the callback context.
> > I should have probably better explained that in the commit info (will
> > include this in the patch v2), but the main thing is: nfc_se_io() is
> > called with se_io_cb callback function as an argument and that callback is 
> > the exact place where an allocated se_io_ctx context should be freed. And
> > it is actually freed there unless some error path happens that leads the
> 
> Exactly, so why nci_hci_send_event() error path should not free it?
> 

nci_hci_send_event() should not free it on its error path because the
bwi_timer is already charged before nci_hci_send_event() is called.

The pattern in the .se_io functions of the corresponding drivers (st-nci,
st21nfca) is following:

	info->se_info.cb = cb;
	info->se_info.cb_context = cb_context;
	mod_timer(&info->se_info.bwi_timer, jiffies +
		  msecs_to_jiffies(info->se_info.wt_timeout)); // <-charged
	info->se_info.bwi_active = true;
	return nci_hci_send_event(...);

As the timer is charged, it will eventually call se_io_cb() to free the
context, even if the error path is taken inside nci_hci_send_event().

Am I missing something?

> > timer which triggers this se_io_cb callback not to be charged at all.
> > 
> 
> 
> Best regards,
> Krzysztof
> 
