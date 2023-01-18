Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5850F672A1D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjARVNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjARVMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:12:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB2159254;
        Wed, 18 Jan 2023 13:12:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3171B81F47;
        Wed, 18 Jan 2023 21:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D15C433D2;
        Wed, 18 Jan 2023 21:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674076335;
        bh=8P80n6qx5S3Q2eIr8WgJ/JcazzRERFHfvAb6s1HWsic=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=EK70jyKqfGLdxWibkaJeYVSwhRafme6D6x85n44Vb4viG5zNdH4iaqo/WILUYd3yI
         +gG4SfH0XxdmsWvFbUb+NKZK1jJPLpwpMhmjgQ8aeGgMfLUf5OJPgfewcjM26uLmXG
         j5ZXDySRLNXZynaay/1vZQ+XYZgcPL/8hfpKiShoQG6nHljMpvIfOqJb/23t5whApn
         29b6cq8k0fD90UHXoyKehRXHiLB4FleXhKblf/J+cHpSl/tdyuZR43Kt6cyXG2Jtht
         sSBhcVaK4QTTCLrnFS1iyq29nuFnuxjgsfGSaqnQ2/Sr6BKR1lEknxXNtvBtBVIGu3
         3BClnxZB2o5ww==
Date:   Wed, 18 Jan 2023 22:12:15 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc:     Greg KH <gregkh@linuxfoundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH HID for-next v2 0/9] HID-BPF LLVM fixes, no more hacks
In-Reply-To: <20230113090935.1763477-1-benjamin.tissoires@redhat.com>
Message-ID: <nycvar.YFH.7.76.2301182211400.1734@cbobk.fhfr.pm>
References: <20230113090935.1763477-1-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Jan 2023, Benjamin Tissoires wrote:

> Hi,
> 
> So this is the fix for the bug that actually prevented me to integrate
> HID-BPF in v6.2.
> 
> While testing the code base with LLVM, I realized that clang was smarter
> than I expected it to be, and it sometimes inlined a function or not
> depending on the branch. This lead to segfaults because my current code
> in linux-next is messing up the bpf programs refcounts assuming that I
> had enough observability over the kernel.
> 
> So I came back to the drawing board and realized that what I was missing
> was exactly a bpf_link, to represent the attachment of a bpf program to
> a HID device. This is the bulk of the series, in patch 6/9.
> 
> The other patches are cleanups, tests, and also the addition of the
> vmtests.sh script I run locally, largely inspired by the one in the bpf
> selftests dir. This allows very fast development of HID-BPF, assuming we
> have tests that cover the bugs :)
> 
> 
> changes in v2:
> - took Alexei's remarks into account and renamed the indexes into
>   prog_table_index and hid_table_index
> - fixed unused function as reported by the Intel kbuild bot

I've now applied this on top of the previous work in 
hid.git#for-6.3/hid-bpf

-- 
Jiri Kosina
SUSE Labs

