Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716616A458A
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 16:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjB0PGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 10:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjB0PGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 10:06:06 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDBB211E5;
        Mon, 27 Feb 2023 07:06:03 -0800 (PST)
Received: from fpc (unknown [10.10.165.11])
        by mail.ispras.ru (Postfix) with ESMTPSA id 66BC240D4004;
        Mon, 27 Feb 2023 15:05:59 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 66BC240D4004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1677510359;
        bh=7vycEZFRFP94oVRohVTC/agOxzdGsMogkS8eps0PN84=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f4pzNAVOUEO50TBEiMZQOCXAg0+n5zlzxmN5cRcSzurJTCqLXXUHsEVeXIayFQOfz
         2effxCNYxZ8GlmziTK4sz/RKw7T6h3qPk4qilnC8zelqa8FctuQsEdWg/CZ+LwS0EX
         D0e9Ah/mS3kmc2382ytS53caa6TNB0ow7HTQzYRs=
Date:   Mon, 27 Feb 2023 18:05:53 +0300
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
Message-ID: <20230227150553.m3okhdxqmjgon4dd@fpc>
References: <20230225105614.379382-1-pchelkin@ispras.ru>
 <b0f65aaa-37aa-378f-fbbf-57d107f29f5f@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0f65aaa-37aa-378f-fbbf-57d107f29f5f@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 11:08:54AM +0100, Krzysztof Kozlowski wrote:
> On 25/02/2023 11:56, Fedor Pchelkin wrote:
> > The callback context for sending/receiving APDUs to/from the selected
> > secure element is allocated inside nfc_genl_se_io and supposed to be
> > eventually freed in se_io_cb callback function. However, there are several
> > error paths where the bwi_timer is not charged to call se_io_cb later, and
> > the cb_context is leaked.
> >
> >The patch proposes to free the cb_context explicitly on those error paths.
>
> Do not use "This commit/patch".
> https://elixir.bootlin.com/linux/v5.17.1/source/Documentation/process/submitting-patches.rst#L95
> 

Will be corrected, sorry.

> > 
> > At the moment we can't simply check 'dev->ops->se_io()' return value as it
> > may be negative in both cases: when the timer was charged and was not.
> > 
> > Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
> > Reported-by: syzbot+df64c0a2e8d68e78a4fa@syzkaller.appspotmail.com
> > Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> > Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> 
> SoB order is a bit odd. Who is the author?
>

The author is me (Fedor). I thought the authorship is expressed with the
first Signed-off-by line, isn't it?

> > ---
> >  drivers/nfc/st-nci/se.c   | 6 ++++++
> >  drivers/nfc/st21nfca/se.c | 6 ++++++
> >  net/nfc/netlink.c         | 4 ++++
> >  3 files changed, 16 insertions(+)
> > 
> > diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
> > index ec87dd21e054..b2f1ced8e6dd 100644
> > --- a/drivers/nfc/st-nci/se.c
> > +++ b/drivers/nfc/st-nci/se.c
> > @@ -672,6 +672,12 @@ int st_nci_se_io(struct nci_dev *ndev, u32 se_idx,
> >  					ST_NCI_EVT_TRANSMIT_DATA, apdu,
> >  					apdu_length)
> nci_hci_send_event() should also free it in its error paths.
> nci_data_exchange_complete() as well? Who eventually frees it? These
> might be separate patches.
> 
> 

nci_hci_send_event(), as I can see, should not free the callback context.
I should have probably better explained that in the commit info (will
include this in the patch v2), but the main thing is: nfc_se_io() is
called with se_io_cb callback function as an argument and that callback is 
the exact place where an allocated se_io_ctx context should be freed. And
it is actually freed there unless some error path happens that leads the
timer which triggers this se_io_cb callback not to be charged at all.

The timer is bwi_timer. It is charged in the .se_io functions of the
corresponding drivers (st-nci, st21nfca):

	info->se_info.cb = cb;
	info->se_info.cb_context = cb_context;
	mod_timer(&info->se_info.bwi_timer, jiffies +
		  msecs_to_jiffies(info->se_info.wt_timeout));

bwi_timer in the drivers is binded to the corresponding timeout callbacks
which in turn call se_io_cb() to eventually free the context.

So, the lifetime of the leaked context is limited to
- being allocated in nfc_genl_se_io()
- passed to nfc_se_io()
- passed to st_nci_se_io() or st21nfca_hci_se_io() driver function 
- there the callback function se_io_cb is scheduled via bwi_timer to free
  the context
- timeout occurs or an event is received (see
  st_nci_hci_apdu_reader_event_received), then the callback is called and
  frees it

st_nci_hci_apdu_reader_event_received() and
st21nfca_apdu_reader_event_receive() are also places of interest as they
deal with bwi_timer, but no need to free context on error path there as
these functions can only be called with bwi_timer already charged so the
se_io_cb callback would be called anyway.

To summarize it, there are only three occurrences of the callback context
leak which I can see and they are all due to the bwi_timer not charged at
all:

1) inside nfc_se_io() -- when some check fails before calling
'dev->ops->se_io()'.

2) inside st_nci_se_io() -- when se_idx isn't ST_NCI_ESE_HOST_ID. In the
case it actually equals to ST_NCI_ESE_HOST_ID, mod_timer() is called so
the se_io_cb callback would be eventually executed and free the context.

3) inside st21nfca_hci_se_io() -- for the similar reasons as in 2).

As you said, I'll divide that into three separate patches. Should I resend
it as a series? (there is actually the same cause of the leak: not freeing
the same object on error paths) 

> >  	default:
> > +		/* Need to free cb_context here as at the moment we can't
> > +		 * clearly indicate to the caller if the callback function
> > +		 * would be called (and free it) or not. In both cases a
> > +		 * negative value may be returned to the caller.
> > +		 */
> > +		kfree(cb_context);
> >  		return -ENODEV;
> >  	}
> >  }
> > diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
> > index df8d27cf2956..dae288bebcb5 100644
> > --- a/drivers/nfc/st21nfca/se.c
> > +++ b/drivers/nfc/st21nfca/se.c
> > @@ -236,6 +236,12 @@ int st21nfca_hci_se_io(struct nfc_hci_dev *hdev, u32 se_idx,
> >  					ST21NFCA_EVT_TRANSMIT_DATA,
> >  					apdu, apdu_length);
> >  	default:
> > +		/* Need to free cb_context here as at the moment we can't
> > +		 * clearly indicate to the caller if the callback function
> > +		 * would be called (and free it) or not. In both cases a
> > +		 * negative value may be returned to the caller.
> > +		 */
> > +		kfree(cb_context);
> >  		return -ENODEV;
> >  	}
> >  }
> > diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
> > index 1fc339084d89..348bf561bc9f 100644
> > --- a/net/nfc/netlink.c
> > +++ b/net/nfc/netlink.c
> > @@ -1442,7 +1442,11 @@ static int nfc_se_io(struct nfc_dev *dev, u32 se_idx,
> >  	rc = dev->ops->se_io(dev, se_idx, apdu,
> >  			apdu_length, cb, cb_context);
> >  
> > +	device_unlock(&dev->dev);
> > +	return rc;
> > +
> >  error:
> > +	kfree(cb_context);
> 
> kfree could be after device_unlock. Although se_io() will free it with
> lock held, but error paths usually unwind everything in reverse order
> LIFO, so first unlock then kfree.
> 

Got it, thanks.
