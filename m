Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7CE57CCC8
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiGUOBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiGUOBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:01:04 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCF43D592;
        Thu, 21 Jul 2022 07:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dlwnS1Fa3TmXXVNwd1KfMLtfg4qW+Hn+l84xHjkNFv4=; b=pM1CVIwQYxiPAKO3GfnMS+lKWM
        v8JWyHbi4HVsskrZQxy4Ji7eppdHhD1UeK7YeES2Rza9Ju3RbEJUXwt5UYgTNVT2z9kdsVJcQZ2L8
        N6sK3PA8ObrNJfk7XzTrJZYWeq5vb9MxU4+a7bb7dfmzv/Ic2EqZMfqBN8NDhXaiSx1krB1zjjBqE
        D6CdkPlu8rryITQUy+7+fBeOogwYiSR19VRwipP0cOL8BciioNlXBMtGct1NVCqFcNqhkzjwMriDU
        fmUlKR/BahxW7dR+bNhJoxAwIaR0xCbzFpxbFgpew/sJHpTkXKvif23GSxed/IZ1m99labnS42keg
        BKnGtb8g==;
Received: from 200-100-212-117.dial-up.telesp.net.br ([200.100.212.117] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oEWjF-001W4c-TX; Thu, 21 Jul 2022 16:00:38 +0200
Message-ID: <81b1f787-c3d4-1b2d-6b56-38f54947835d@igalia.com>
Date:   Thu, 21 Jul 2022 11:00:11 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 07/13] parisc: Replace regular spinlock with
 spin_trylock on panic path
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>, Jeroen Roovers <jer@xs4all.nl>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, linux-parisc@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-8-gpiccoli@igalia.com>
 <20220720034300.6d2905b8@wim.jer>
 <76b6f764-23a9-ed0b-df3d-b9194c4acc1d@igalia.com>
 <7e5dce87-31c1-401f-324a-2aacb6996625@gmx.de>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <7e5dce87-31c1-401f-324a-2aacb6996625@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/07/2022 10:45, Helge Deller wrote:
> [...]
> Guilherme, I'd really prefer that you push the whole series at once through
> some generic tree.
> 
> Helge

Hmm..OK.

Some maintainers will take patches from here and merge, but given your
preference I can talk to Andrew to see if the can pick via his tree
(along with the generic panic patches).

Cheers,


Guilherme
