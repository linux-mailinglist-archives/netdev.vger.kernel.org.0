Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229536074FA
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 12:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiJUK1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 06:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJUK1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 06:27:32 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480B62565E7;
        Fri, 21 Oct 2022 03:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=Kb4GP8DAreI8S/J2byURlpp2EiVOpoaHEyYyicfid1k=; b=x8JWXsOk6ysRahrcxdiURaVS1r
        Ey8DuVmvMmjASeaACCgc2rw5D0aR44ta/gOGzOJ3KIlCXItcniqz6/dh4eGsiG7grMDt/ivw2ryOM
        qn4LgewJHPlC409JS+FUseSPtLuRfOTJpxpxIpUBGLCcqGmvnkHztsS6RyGCDY9CJTKmFr9XQMPsw
        xIfEzWIDhwh1unV5pCZ93trTJfd+X15AYmNY9cG0+2PmgAK7SdgUyO23r5gtBL5/WbloXZpGCHoC2
        b1MNgKasCO3x9ZIBuT5n8JMbmZljLedNT0QujXurTuLkq0QEMx8Xj+C8cuh8aIUmVUVQy8v8lpa88
        wr8Z68uxMtBQe0bDxrgQaeQDvqf77nJSTE7boRmd1LHbG5kVpLqf2p2DjKg40Ui934zS4Cyv5SJYF
        8vkhWT9ub8/p1s3kMnFejqwfcic96QG5JLAaIXK/av8+NT+26AKC3fH9NfHdlpbCqU+9iOkFvUsSW
        pIsclVDNynyzXn55KogYSuzc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olpFQ-00591t-CC; Fri, 21 Oct 2022 10:27:28 +0000
Message-ID: <d4d6f627-46cc-8176-6d52-c93219db8c2f@samba.org>
Date:   Fri, 21 Oct 2022 12:27:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <cover.1666346426.git.asml.silence@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH for-6.1 0/3] fail io_uring zc with sockets not supporting
 it
In-Reply-To: <cover.1666346426.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

> Some sockets don't care about msghdr::ubuf_info and would execute the
> request by copying data. Such fallback behaviour was always a pain in
> my experience, so we'd rather want to fail such requests and have a more
> robust api in the future.
> 
> Mark struct socket that support it with a new SOCK_SUPPORT_ZC flag.
> I'm not entirely sure it's the best place for the flag but at least
> we don't have to do a bunch of extra dereferences in the hot path.

I'd give the flag another name that indicates msg_ubuf and
have a 2nd flag that can indicate support for SO_ZEROCOPY in sk_setsockopt()

The SO_ZEROCOPY version is also provided by AF_RDS.

metze
