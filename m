Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6595C273B3A
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 08:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgIVGwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 02:52:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:47386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727710AbgIVGwI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 02:52:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 18026AD65;
        Tue, 22 Sep 2020 06:52:44 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 2D3EC60731; Tue, 22 Sep 2020 08:52:07 +0200 (CEST)
Date:   Tue, 22 Sep 2020 08:52:07 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH ethtool] bnxt: Add Broadcom driver support.
Message-ID: <20200922065207.yann26svrf32bnsd@lion.mk-sys.cz>
References: <1600670391-5533-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200921091820.hiulkidpedzgl4lz@lion.mk-sys.cz>
 <CAACQVJo1YCFsxTeUi7T_+0AtrDzYGAY-CRZXvm31NXbQ41CCTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJo1YCFsxTeUi7T_+0AtrDzYGAY-CRZXvm31NXbQ41CCTQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 11:24:24AM +0530, Vasundhara Volam wrote:
> On Mon, Sep 21, 2020 at 2:48 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > > +             return -1;
> > > +     }
> > > +
> > > +     pcie_stats = (u16 *)(regs->data + BNXT_PXP_REG_LEN);
> > > +     fprintf(stdout, "PCIe statistics:\n");
> > > +     fprintf(stdout, "----------------\n");
> > > +     for (i = 0; i < ARRAY_SIZE(bnxt_pcie_stats); i++) {
> > > +             pcie_stat = 0;
> > > +             memcpy(&pcie_stat, &pcie_stats[stats[i].offset],
> > > +                    stats[i].size * sizeof(u16));
> >
> > This will only work on little endian architectures.
> 
> Data is already converted to host endian order by ETHTOOL_REGS, so it
> will not be an issue.

It does not work correctly. Assume we are on big endian architecture and
are reading a 16-bit value (stats[i].size = 1) 0x1234 which is laid out
in memory as

    ... 12 34 ...

Copying that by memcpy() to the address of 64-bit pcie_stat, you get

   12 34 00 00 00 00 00 00

which represents 0x1234000000000000, not 0x1234. You will also have the
same problem with 32-bit values (stats[i].size = 2).

Michal
