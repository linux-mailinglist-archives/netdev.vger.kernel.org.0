Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078CD6DCCDE
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 23:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjDJVh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 17:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjDJVh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 17:37:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBC51731;
        Mon, 10 Apr 2023 14:37:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CAF561ED1;
        Mon, 10 Apr 2023 21:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF2BC433EF;
        Mon, 10 Apr 2023 21:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681162675;
        bh=nInAUa6amMudrI8XEJL1TpR3ESFkYUHEKUku5oaWNKA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=DzLbS6KrP/rrdDllYm/O2I3oH3pJyDW4jebSqhrbwp7E0WV32c4lv9i7QBsiRViCi
         WthOOONKfQaRoVBC3phTcqYDc3FUb73jA7nzyQrw4O2X+s6nNF+GwnWKTNSMMtJ3GP
         EVbqhJbc9V/QLQ10TnG9BA3l45Sv+aX1aI6Rmla2qFpAUog4pNjTCBynOFFr5VFTHd
         XnPckJtmuDVoXtRDT+ulajPlSbtzUQzl7ODCO6pyKca9DF8sqCiBtGZFV79GfuHHa2
         a/+Fr12VKF6WSp4Jn9IChB+LymOhcUJ9yG4L/ATm0fkC6B9LqxzDCNNmnhtvk8cmKt
         y1IyR1e7nkxoQ==
Date:   Mon, 10 Apr 2023 16:37:54 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [BUG] net, pci: 6.3-rc1-4 hangs during boot on PowerEdge R620
 with igb
Message-ID: <20230410213754.GA4064490@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD4GDZyVVoFmmBFY5hGQ9xbqRD=LzMfe7zVjDThiC589zT8uvQ@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 04:10:54PM +0100, Donald Hunter wrote:
> On Sun, 2 Apr 2023 at 23:55, Bjorn Helgaas <helgaas@kernel.org> wrote:
> > On Sat, Apr 01, 2023 at 01:52:25PM +0100, Donald Hunter wrote:
> > > On Fri, 31 Mar 2023 at 20:42, Bjorn Helgaas <helgaas@kernel.org> wrote:
> > > >
> > > > I assume this igb NIC (07:00.0) must be built-in (not a plug-in card)
> > > > because it apparently has an ACPI firmware node, and there's something
> > > > we don't expect about its status?
> > >
> > > Yes they are built-in, to my knowledge.
> > >
> > > > Hopefully Rob will look at this.  If I were looking, I would be
> > > > interested in acpidump to see what's in the DSDT.
> > >
> > > I can get an acpidump. Is there a preferred way to share the files, or just
> > > an email attachment?
> >
> > I think by default acpidump produces ASCII that can be directly
> > included in email.  http://vger.kernel.org/majordomo-info.html says
> > 100K is the limit for vger mailing lists.  Or you could open a report
> > at https://bugzilla.kernel.org and attach it there, maybe along with a
> > complete dmesg log and "sudo lspci -vv" output.
> 
> Apologies for the delay, I was unable to access the machine while travelling.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=217317

Thanks for that!  Can you boot a kernel with 6fffbc7ae137 reverted
with this in the kernel parameters:

  dyndbg="file drivers/acpi/* +p"

and collect the entire dmesg log?
