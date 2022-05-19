Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0973952CDF6
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 10:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbiESILJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 04:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbiESILF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 04:11:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2FA32ED4;
        Thu, 19 May 2022 01:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=P7hBfgfR5V/lg9pLTdIBC/hWy6eM9dq7h/FVFtkFAq8=; b=rdosXHdo2i8UPLrk/NfgCsQQXa
        NceHcHgDpc15rlXcvlJlOrvKZ07wttU2W4xYEEJ6/rwixNTeoFQGrtYIfP88p3Ebs08aAqDTCIgNz
        pLdQx96nbRVquBG/2pxsNXQCMYj08yyvHjs1NkoW9tWhq0aCFNmUPZVm0RT+FxOycqrOLtkimO1gU
        qVdbj5lP7g6hJLzWrzaga1BFb3fwvsbBm6/6U5xAB3UEw/VdGyTJZ6qYAs7dAErfDL0kHi1ZTR5jm
        OpDM/iSINt2WRl+K0pmS1DIg6BnDkcGe3O+dUNeHJrXrDUtyifs6d74AsrJbhyhbCDXwNL+hCKQCR
        CXtb89mQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrbFA-005iMY-O2; Thu, 19 May 2022 08:10:48 +0000
Date:   Thu, 19 May 2022 01:10:48 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
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
Message-ID: <YoX7iHddAd4FkQRQ@infradead.org>
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The logic is the following (see also the last patch for some more
> documentation):
> - hid-bpf first preloads a BPF program in the kernel that does a few
>   things:
>    * find out which attach_btf_id are associated with our trace points
>    * adds a bpf_tail_call() BPF program that I can use to "call" any
>      other BPF program stored into a jump table
>    * monitors the releases of struct bpf_prog, and when there are no
>      other users than us, detach the bpf progs from the HID devices
> - users then declare their tracepoints and then call
>   hid_bpf_attach_prog() in a SEC("syscall") program
> - hid-bpf then calls multiple time the bpf_tail_call() program with a
>   different index in the jump table whenever there is an event coming
>   from a matching HID device

So driver abstractions like UDI are now perfectly fine as long as they
are written using a hip new VM?

This whole idea seems like a bad idea, against the Linux spirit and
now actually useful - it is totally trivial to write a new HID
driver alreay, and if it isn't in some cases we need to fix that.

So a big fat NAK to the idea of using eBPF for actual driver logic.
