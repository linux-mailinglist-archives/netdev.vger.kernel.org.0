Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D9126885D
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 11:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgINJaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 05:30:23 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38662 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgINJaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 05:30:21 -0400
Received: by mail-wm1-f67.google.com with SMTP id l9so10496257wme.3;
        Mon, 14 Sep 2020 02:30:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pZLqqybXXQgA/IZC4tJFYXMy5fXU6skvhtRUlKnQzKw=;
        b=Qs653CAq8kBIy4n9EnBci2wA52LsG89rVNHYyO/vwdF/3ybOJF9+B6ehZLik5n24aq
         Ext9LBc1+KIfdiVwE6z2StB3jBRGvbQUQazdtVdlF2K3UXi/mzgNoE/G935A8RYxH6S6
         vOkdcDMSUqEAZzDLanUPb+6DH1GrCTxPgFRw5fnn+TSz0w7CpSbeDTZ7cm495Abc3kKs
         Oc2mGXM0+5D5UVdW6uLU9wujwtVc+Wg1+TXAND64+oxirBzc51MAOvXTFBkal5X5y4jT
         L1Fgj2S116J0ATpP3l5C93JLd4xhnmyif/5Bn1UYwl0akFtr+/CY+ney/T0tkW7LPOf1
         R5Pw==
X-Gm-Message-State: AOAM533Entn7xCaKjDj5A/4xPDBsVa5ZfQ8X+0MbPVyvKyrhhYAFOv6J
        KmeNhhAqVbD97Ovmw7zds20=
X-Google-Smtp-Source: ABdhPJwHIBCL7ODGI6zpiUTSttE5rh5EQeZYIwYnSf7V/9lo2HMb3CSQThgbfvgxOyQabcDR9C08UA==
X-Received: by 2002:a7b:c1c3:: with SMTP id a3mr15248600wmj.68.1600075818330;
        Mon, 14 Sep 2020 02:30:18 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id 185sm19690077wma.18.2020.09.14.02.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 02:30:17 -0700 (PDT)
Date:   Mon, 14 Sep 2020 09:30:16 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>, will@kernel.org,
        ardb@kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        mark.rutland@arm.com, maz@kernel.org
Subject: Re: [PATCH v3 08/11] Input: hyperv-keyboard: Make ringbuffer at
 least take two pages
Message-ID: <20200914093016.lsfrfk4c7kyj6tn3@liuwe-devbox-debian-v2>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-9-boqun.feng@gmail.com>
 <20200914084600.GA45838@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914084600.GA45838@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 04:46:00PM +0800, Boqun Feng wrote:
> On Thu, Sep 10, 2020 at 10:34:52PM +0800, Boqun Feng wrote:
> > When PAGE_SIZE > HV_HYP_PAGE_SIZE, we need the ringbuffer size to be at
> > least 2 * PAGE_SIZE: one page for the header and at least one page of
> > the data part (because of the alignment requirement for double mapping).
> > 
> > So make sure the ringbuffer sizes to be at least 2 * PAGE_SIZE when
> > using vmbus_open() to establish the vmbus connection.
> > 
> > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > ---
> >  drivers/input/serio/hyperv-keyboard.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
> > index df4e9f6f4529..6ebc61e2db3f 100644
> > --- a/drivers/input/serio/hyperv-keyboard.c
> > +++ b/drivers/input/serio/hyperv-keyboard.c
> > @@ -75,8 +75,8 @@ struct synth_kbd_keystroke {
> >  
> >  #define HK_MAXIMUM_MESSAGE_SIZE 256
> >  
> > -#define KBD_VSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
> > -#define KBD_VSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
> > +#define KBD_VSC_SEND_RING_BUFFER_SIZE	max(40 * 1024, (int)(2 * PAGE_SIZE))
> > +#define KBD_VSC_RECV_RING_BUFFER_SIZE	max(40 * 1024, (int)(2 * PAGE_SIZE))
> >  
> 
> Hmm.. just realized there is a problem here, if PAGE_SIZE = 16k, then
> 40 * 1024 > 2 * PAGE_SIZE, however in the ring buffer size should also
> be page aligned, otherwise vmbus_open() will fail.
> 
> I plan to modify this as
> 
> in linux/hyperv.h:
> 
> #define VMBUS_RING_SIZE(payload_sz) PAGE_ALIGN(sizeof(struct hv_ring_buffer) + (playload_sz))
> 
> and here:
> 
> #define KBD_VSC_SEND_RING_BUFFER_SIZE VMBUS_RING_SIZE(36 * 1024)
> #define KBD_VSC_RECV_RING_BUFFER_SIZE VMBUS_RING_SIZE(36 * 1024)
> 
> and the similar change for patch #9.

OOI why do you reduce the size by 4k here?

Wei.

> 
> Thoughts?
> 
> Regards,
> Boqun
> 
> >  #define XTKBD_EMUL0     0xe0
> >  #define XTKBD_EMUL1     0xe1
> > -- 
> > 2.28.0
> > 
