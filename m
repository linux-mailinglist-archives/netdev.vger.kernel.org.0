Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0580F1334DD
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgAGVaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:30:23 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34173 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgAGVaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:30:22 -0500
Received: by mail-ed1-f68.google.com with SMTP id l8so863494edw.1
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 13:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JcLVM+Dsgsha7A1/NUMX4PuNXV8YonUnES75a0YkZ8U=;
        b=LRoEkYHxKxeR9C5IwREOTayIY9hCxrjmRkP8Y22RORGyPxgz/Q5o0PFw1mNyP5Nu6G
         6xc/1vqblqL511Z+ap+0zDraM++1GWu0MwOBfUbN0eMpIEQvvmR3tOGt8oCWl+Y9hzwz
         qpK3q7SBw/EEaRv3w8ZdAsiyGc26V54JOS2jKQNbUhMcwpC7zKrLVuENopLCy3NI+hEJ
         o1UKiTushmBz19B4L8SaUIsB8NRHeYPEs6SdyhlI2FS/aOQSf8vmOfjB1BxLlHyXyjUU
         JeXugWbXRom3eHECrpgqP0DH94LknWizYTo/AM+tG+0RiOeOddmLK0YMXKbrfdLEdpWJ
         rmyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JcLVM+Dsgsha7A1/NUMX4PuNXV8YonUnES75a0YkZ8U=;
        b=ccS3qTJEynaYRq3Mn3FsSJIbIucbyCF7ZsmCh88OiSF61D9urKfdXUrVF8oWgMm8QO
         wrSio6jKCEvqbXE4iCFNMfAffb3TQMtsnPiBCsNm+Kf9+PHOdHA3PCF84hriyxitANI6
         O3H8p+G+lG+iSpgf9GTdJujDeywotEzasXXja3XJMtVj1hYPGMKWO9yjNui6F8+6OZtS
         QC7g1Qqld3CehNfjplRjHtBERSVILHzyM5UAnsS+RmdERmCjMHCn2H7WI/CrOUirhyHm
         bFNwLvS0e8CW3uR7O3WyiT3m3sp/Y73xay6B23cG2p/Gk11gi5oXJADRjf5xJD4iWeI8
         tSOg==
X-Gm-Message-State: APjAAAXqI/ikADTy+pRNsDXDfrgDKn0nU9xGSwEaDL6hc7LCdFGdLyhs
        3oSM+I/s/55dTFf31ldctw8K8aeqMzoJ6SuJ2yk=
X-Google-Smtp-Source: APXvYqyNZzPY/dN7Sbtdssx8HbM6vHPJg+RHV3Eg+NYgSw9jXWxoZBrm4quTbp/Q1VtvGAaKbaNskkkCUSBnpIXJhoo=
X-Received: by 2002:aa7:d34d:: with SMTP id m13mr2120600edr.140.1578432620581;
 Tue, 07 Jan 2020 13:30:20 -0800 (PST)
MIME-Version: 1.0
References: <20200107034349.59268-1-snelson@pensando.io> <20200107034349.59268-4-snelson@pensando.io>
 <20200107130949.GA23819@lunn.ch> <112c6fd3-6565-e88a-dde5-520770d9f024@pensando.io>
 <20200107194536.GB16895@lunn.ch>
In-Reply-To: <20200107194536.GB16895@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 7 Jan 2020 23:30:09 +0200
Message-ID: <CA+h21hpa4QuoEfdSj6hoaoK2y+7OJLyrpvXkJoOu7EvYMZ+8=w@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/4] ionic: restrict received packets to mtu size
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Shannon Nelson <snelson@pensando.io>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, 7 Jan 2020 at 21:46, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Hi Andrew,
> >
>
> Hi Shannon
>
> > In my experience the driver typically tells the NIC about the current
> > max_frame size (e.g. MTU + ETH_HLEN), the NIC only copies max_frame bytes,
> > and the NIC returns an error indication on a packets that had more than
> > max_frame.
>
> Having played around with a few different NICs for DSA, it seems more
> like 75% don't care about the 'MRU' and will happily accept bigger
> frames.
>
> Anyway, it does not hurt to drop received frames bigger than what you
> can transmit.

In the general case, would we want a knob in Linux for the MRU, or is
it ok to go ahead with patches such as this one, and e.g. set up port
policers for limiting the frame length at the value of the MTU?

>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
>     Andrew

-Vladimir
