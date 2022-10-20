Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DCE605BE2
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiJTKKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiJTKKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:10:39 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3539EF5A0;
        Thu, 20 Oct 2022 03:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=HUHMjvy6X1ykgOyrAFE3euzxp8Bf/zIF9a/YZERB/To=; b=0ZGajmakJWAyWuagWTPYViA5BH
        yJHeAo2sws0f10Qop1dftuz2jCwFSFYy3/ILN4OCRQPFVfEvQzv3PpEXCOQ4cNIsYO1GGCG8/4KM2
        uahYrZxVR9CblGg4IKgta/epOUBOMCR8L9x3n1e857TNjWL/0VCmkDQgramw6+mpL9HAu/2mleWjs
        mH67wqmxZNuMWzFkI42j6J+7czaEirGr+T+t4G4Ygbo2nf4XhwD4YqupNuTbmpoL727ZVZk7g8NJC
        wmKWkmE8yKZFvgrZH/qHD17TDYbXtl+DMoEK+kaUQoZPcYEUyv9oJKTY3DmhL0asGY3lx9ipjJqCz
        zJJRxfpdwHkc7ThhwyBQ4F9gPB1xc9W7hkKObadfOUKAic07PEwt46szjZEkPsKL8OF1U83mrsV/o
        lUdMMBQNsI0zZ6ieKBPgqpdmpz/nLoHOaeLmmihHGLmyUdZkWd/mbBzFZ/lGjcsg9NRU385erHvhk
        3uI1GcQNuNzphQ8q2EL/mEBG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olSVS-004zoW-MR; Thu, 20 Oct 2022 10:10:30 +0000
Message-ID: <3e7b7606-c655-2d10-f2ae-12aba9abbc76@samba.org>
Date:   Thu, 20 Oct 2022 12:10:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US, de-DE
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
 <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
 <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: IORING_SEND_NOTIF_USER_DATA (was Re: IORING_CQE_F_COPIED)
In-Reply-To: <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

>> Experimenting with this stuff lets me wish to have a way to
>> have a different 'user_data' field for the notif cqe,
>> maybe based on a IORING_RECVSEND_ flag, it may make my life
>> easier and would avoid some complexity in userspace...
>> As I need to handle retry on short writes even with MSG_WAITALL
>> as EINTR and other errors could cause them.
>>
>> What do you think?

Any comment on this?

IORING_SEND_NOTIF_USER_DATA could let us use
notif->cqe.user_data = sqe->addr3;

metze

