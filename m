Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A4494BCD
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfHSReo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:34:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42394 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbfHSReo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 13:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cEDa1jd0IM5tnPDrGC/SEB2nMeNbumnHk7r8JEYNkc0=; b=xStubRN+WGxodKGmzl2+tPIHGy
        n1dc7ihOw9y7O/sGpHvmsbrrouAa1kpbVZS8qqLOb5vxTkwi1oUg1eIFhQ91KzdgFVyCaI+g5Pf/L
        PgfrmKT5CQlZMhpBVb+d89HsC9uVnZlBSO0OueriT+N5dyGbL7vyaDcKZHw7zg9Clw6A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hzlYH-00082s-Gr; Mon, 19 Aug 2019 19:34:41 +0200
Date:   Mon, 19 Aug 2019 19:34:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: extend PTP gettime
 function to read system clock
Message-ID: <20190819173441.GB29991@lunn.ch>
References: <20190816163157.25314-1-h.feurstein@gmail.com>
 <20190816163157.25314-3-h.feurstein@gmail.com>
 <20190819132733.GE8981@lunn.ch>
 <CAFfN3gUNrnjdOt8bW2EugzjSZMb_vvdEaLN0yOv_06=roqcJYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFfN3gUNrnjdOt8bW2EugzjSZMb_vvdEaLN0yOv_06=roqcJYQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 07:14:25PM +0200, Hubert Feurstein wrote:
> Hi Andrew,
> 
> Am Mo., 19. Aug. 2019 um 15:27 Uhr schrieb Andrew Lunn <andrew@lunn.ch>:
> >
> > > @@ -45,7 +45,8 @@ static int mv88e6xxx_smi_direct_write(struct mv88e6xxx_chip *chip,
> > >  {
> > >       int ret;
> > >
> > > -     ret = mdiobus_write_nested(chip->bus, dev, reg, data);
> > > +     ret = mdiobus_write_sts_nested(chip->bus, dev, reg, data,
> > > +                                    chip->ptp_sts);
> > >       if (ret < 0)
> > >               return ret;
> > >
> >
> > Please also make a similar change to mv88e6xxx_smi_indirect_write().
> > The last write in that function should be timestamped.
> Since it is already the last write it should be already ok (The
> mv88e6xxx_smi_indirect_write
> calls the mv88e6xxx_smi_direct_write which initiates the timestamping).

Hi Hubert

But you are also time stamping the first write as well. And it seems
like it is not completely for free. So it would be nice to limit it to
the write which actually matters.

    Andrew
