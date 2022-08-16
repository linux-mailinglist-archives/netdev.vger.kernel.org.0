Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13AAD5963A0
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 22:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiHPURR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 16:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbiHPURQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 16:17:16 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191C4895C2;
        Tue, 16 Aug 2022 13:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pZZrETtmIKdExVtzVzQ8UXA3eX9WZ6xF2u4zNFYqj/s=; b=ptR8j4dyawkqM37lf86AbKOFwy
        vqD50LNT3FK4b3Ha/zFTVqxf8zbh3as0oeroZaX2TnivXLllApZfmMbDzp8qAWTXqFTbpSfaGHF0M
        fGxN+PX2kx8r82YMpSjijG5sV1i4AJ3z7/651SDn3tt7vvF34lL8Cw1zArzLWGGCqiDFTlnFroQ/O
        5az02/1DGkptKGyHRtFk1d5VW8G2DCfsRqvfE6Zwy5OCe/NROVnv7MEnif7q2Ohiv81GpvC/S4Fqf
        dBzhukKSo/tmSLNp0plhiwEcbku8B/ZsP+BOQSlMf5f1yudhZ/U0xeMxA3KNfSl3VsKfa80FtLsYm
        TV6FA3wA==;
Received: from [179.232.144.59] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oO2zs-00AHrG-K9; Tue, 16 Aug 2022 22:17:08 +0200
Message-ID: <7da27e6f-ff45-9b28-5b67-ab8eabca1ed2@igalia.com>
Date:   Tue, 16 Aug 2022 17:16:45 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 10/13] EDAC/altera: Skip the panic notifier if kdump is
 loaded
Content-Language: en-US
To:     Dinh Nguyen <dinguyen@kernel.org>, kexec@lists.infradead.org,
        linux-edac@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        bp@alien8.de
Cc:     akpm@linux-foundation.org, pmladek@suse.com, bhe@redhat.com,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-11-gpiccoli@igalia.com>
 <9f114876-d402-6e74-c1db-4e4983c2d695@kernel.org>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <9f114876-d402-6e74-c1db-4e4983c2d695@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/08/2022 15:44, Dinh Nguyen wrote:
> [...] 
>> V2:
>> - new patch, based on the discussion in [0].
>> [0] https://lore.kernel.org/lkml/62a63fc2-346f-f375-043a-fa21385279df@igalia.com/
>>
> 
> Acked-by: Dinh Nguyen <dinguyen@kernel.org>

Thanks a lot Dinh!

There is something I'm asking for maintainers on patches in this series,
so here it goes for you (CC Borislav / Tony): do you think it's possible
to pick this one in your tree directly, from this series, or do you
prefer I re-submit as a standalone patch, on linux-edac maybe?

Thanks,


Guilherme
