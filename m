Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD31248D44
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 19:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgHRRgc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Aug 2020 13:36:32 -0400
Received: from wildebeest.demon.nl ([212.238.236.112]:50288 "EHLO
        gnu.wildebeest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbgHRRgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 13:36:23 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Aug 2020 13:36:21 EDT
Received: from tarox.wildebeest.org (tarox.wildebeest.org [172.31.17.39])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by gnu.wildebeest.org (Postfix) with ESMTPSA id 8197F30278CD;
        Tue, 18 Aug 2020 19:29:56 +0200 (CEST)
Received: by tarox.wildebeest.org (Postfix, from userid 1000)
        id 2FDCF401443A; Tue, 18 Aug 2020 19:29:56 +0200 (CEST)
Message-ID: <c9c4a42ba6b4d36e557a5441e90f7f4961ec3f72.camel@klomp.org>
Subject: Re: Kernel build error on BTFIDS vmlinux
From:   Mark Wielaard <mark@klomp.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, sdf@google.com,
        andriin@fb.com, nickc@redhat.com
Date:   Tue, 18 Aug 2020 19:29:56 +0200
In-Reply-To: <20200818183318.2c3fe4a2@carbon>
References: <20200818105555.51fc6d62@carbon> <20200818091404.GB177896@krava>
         <20200818105602.GC177896@krava> <20200818134543.GD177896@krava>
         <20200818183318.2c3fe4a2@carbon>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
X-Spam-Flag: NO
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.0
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on gnu.wildebeest.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Adding Nick, the binutils maintainer, so we can make sure
binutils/elfutils agree on some ELF section compression corner case.

On Tue, 2020-08-18 at 18:33 +0200, Jesper Dangaard Brouer wrote:
> On Tue, 18 Aug 2020 15:45:43 +0200
> Jiri Olsa <jolsa@redhat.com> wrote:
> 
> > On Tue, Aug 18, 2020 at 12:56:08PM +0200, Jiri Olsa wrote:
> > > On Tue, Aug 18, 2020 at 11:14:10AM +0200, Jiri Olsa wrote:  
> > > > On Tue, Aug 18, 2020 at 10:55:55AM +0200, Jesper Dangaard Brouer wrote:  
> > > > > 
> > > > > On latest DaveM net-git tree (06a4ec1d9dc652), after linking (LD vmlinux) the
> > > > > "BTFIDS vmlinux" fails. Are anybody else experiencing this? Are there already a
> > > > > fix? (just returned from vacation so not fully up-to-date on ML yet)
> > > > > 
> > > > > The tool which is called and error message:
> > > > >   ./tools/bpf/resolve_btfids/resolve_btfids vmlinux
> > > > >   FAILED elf_update(WRITE): invalid section alignment  
> > > > 
> > > > hi,
> > > > could you send your .config as well?  
> > > 
> > > reproduced.. checking on fix  
> > 
> > I discussed this with Mark (cc-ed) it seems to be a problem
> > with linker when dealing with compressed debug info data,
> > which is enabled in your .config
> > 
> > it works for me when I disable CONFIG_DEBUG_INFO_COMPRESSED option
> 
> Thanks for finding this!
> I confirm that disabling CONFIG_DEBUG_INFO_COMPRESSED fixed the issue.
> 
> > Mark will fix this upstream, meanwhile he suggested workaround
> > we can do in resolve_btfids tool, that I'll try to send shortly
> 
> Great!

So, the issue is that there is some confusion about the correct
alignment of compressed ELF sections.

When an ELF section is compressed using gabi-zlib it contains a header
(a Elf_Chdr32 or Elf_Chdr64, followed by the compressed data) The
header explains how the section data is compressed, what the exploded
size is, what the alignment of that uncompressed data is, etc.

Because of this header the section data should be aligned to 4 (for
32bit) or 8 (for 64 bit) bytes, but binutils ld sets sh_addralign to 1.
[*]

elfutils libelf is liberal in what it accepts, and internally fixes up
the alignment if it is wrong. Which is why we probably didn't see this
before. But it won't let you write out misaligned data like that. Which
is slightly confusing, because if you didn't change that section data,
it is not immediately clear why you are getting an error.

Also if you would decompress the section data to use it and then
recompress it elfutils libelf would set sh_addralign correctly for you.
But it won't if you don't use the (uncompressed) data.

The workaround would be to explicitly set the alignment of the
compressed section before writing out the section. Which is what Jiri
is now testing.

But it would obviously be better if that wasn't necessary. So I'll try
to fix libelf so that if it fixes up the alignment when reading the
compressed data, it also does that when writing out the data again. But
that would only help for a new version of elfutils.

So it would be nice if binutils ld could also be fixed to write out
compressed sections with the correct alignment.

Then hopefully if someone has either a new elfutils or a new binutils
it just works without needing any workarounds.

Cheers,

Mark

[*] If this sounds vaguely familiar then that is because we did have a
different alignment bug, but for the uncompressed data (which is the
alignment set in the compression header):
https://bugzilla.redhat.com/show_bug.cgi?id=1678204
That bug was about ch_addralign, this bug is about sh_addralign.
