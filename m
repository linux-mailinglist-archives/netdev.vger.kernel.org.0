Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33BF52D095
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 12:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbiESKcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 06:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiESKco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 06:32:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCAC41625;
        Thu, 19 May 2022 03:32:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5C8661A7F;
        Thu, 19 May 2022 10:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8007CC385AA;
        Thu, 19 May 2022 10:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652956362;
        bh=IToSr7D1OsOQmEo9v4/Bd9h0QuIcI8KL8minv5TWqyM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KANpaT1JqM5SZ7RCfAZTaT+yyqyfAw8nDaIHyC8S0tdXUADa830BTYQyEXUHm9BWS
         a0fPMW4gSs11XQM68Z/Ch0FrVd4fxGz4hbyDR6ImAJa2nZ6QnDXUm4NxhMWpQq+1MI
         CCGo8cGwIEUUoW/MDQ5ssIh+GO4fi5Q00Lg7zYHk=
Date:   Thu, 19 May 2022 12:32:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 00/17] Introduce eBPF support for HID devices
Message-ID: <YoYcw5a6EOvVPzay@kroah.com>
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
 <YoX7iHddAd4FkQRQ@infradead.org>
 <YoX904CAFOAfWeJN@kroah.com>
 <YoYCIhYhzLmhIGxe@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoYCIhYhzLmhIGxe@infradead.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 01:38:58AM -0700, Christoph Hellwig wrote:
> On Thu, May 19, 2022 at 10:20:35AM +0200, Greg KH wrote:
> > > are written using a hip new VM?
> > 
> > Ugh, don't mention UDI, that's a bad flashback...
> 
> But that is very much what we are doing here.
> 
> > I thought the goal here was to move a lot of the quirk handling and
> > "fixup the broken HID decriptors in this device" out of kernel .c code
> > and into BPF code instead, which this patchset would allow.
> > 
> > So that would just be exception handling.  I don't think you can write a
> > real HID driver here at all, but I could be wrong as I have not read the
> > new patchset (older versions of this series could not do that.)
> 
> And that "exception handling" is most of the driver.

For a number of "small" drivers, yes, that's all there is as the
hardware is "broken" and needs to be fixed up in order to work properly
with the hid core code.  An example of that would be hid-samsung.c which
rewrites the descriptors to be sane and maps the mouse buttons properly.

But that's it, after initialization that driver gets out of the way and
doesn't actually control anything.  From what I can tell, this patchset
would allow us to write those "fixup the mappings and reports before the
HID driver takes over" into ebpf programs.

It would not replace "real" HID drivers like hid-rmi.c that has to
handle the events and do other "real" work here.

Or I could be reading this code all wrong, Benjamin?

But even if it would allow us to write HID drivers as ebpf, what is
wrong with that?  It's not a licensing issue (this api is only allowed
for GPL ebpf programs), it should allow us to move a bunch of in-kernel
drivers into smaller ebpf programs instead.

It's not like this ebpf HID driver would actually work on any other
operating system, right?  I guess Microsoft could create a gpl-licensed
ebpf HID layer as well?  As Windows allows vendors to do all of this
horrible HID fixups in userspace today anyway, I strongly doubt they
would go through the effort to add a new api like this for no valid
reason.

thanks,

greg k-h
