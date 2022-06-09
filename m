Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB765457CF
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 01:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345834AbiFIXDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 19:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbiFIXDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 19:03:41 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B069C3A8A4B;
        Thu,  9 Jun 2022 16:03:37 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 3364758723354; Fri, 10 Jun 2022 01:03:36 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 30D9E60C247C4;
        Fri, 10 Jun 2022 01:03:36 +0200 (CEST)
Date:   Fri, 10 Jun 2022 01:03:36 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Bill Wendling <morbo@google.com>
cc:     Andrew Morton <akpm@linux-foundation.org>,
        Bill Wendling <isanbard@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jan Kara <jack@suse.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Ross Philipson <ross.philipson@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        linux-edac@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-mm@kvack.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Networking <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        clang-built-linux <llvm@lists.linux.dev>
Subject: Re: [PATCH 00/12] Clang -Wformat warning fixes
In-Reply-To: <CAGG=3QXDt9AeCQOAp1311POFRSByJru4=Q=oFiQn3u2iZYk2_w@mail.gmail.com>
Message-ID: <nssn2ps-6n86-nqq6-9039-72847760nnq@vanv.qr>
References: <20220609221702.347522-1-morbo@google.com> <20220609152527.4ad7862d4126e276e6f76315@linux-foundation.org> <CAGG=3QXDt9AeCQOAp1311POFRSByJru4=Q=oFiQn3u2iZYk2_w@mail.gmail.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Friday 2022-06-10 00:49, Bill Wendling wrote:
>On Thu, Jun 9, 2022 at 3:25 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Thu,  9 Jun 2022 22:16:19 +0000 Bill Wendling <morbo@google.com> wrote:
>>
>> > This patch set fixes some clang warnings when -Wformat is enabled.
>>
>> tldr:
>>
>> -       printk(msg);
>> +       printk("%s", msg);
>>
>> Otherwise these changes are a
>> useless consumer of runtime resources.
>
>Calling a "printf" style function is already insanely expensive.
>[...]
>The "printk" and similar functions all have the "__printf" attribute.
>I don't know of a modification to that attribute which can turn off
>this type of check.

Perhaps you can split vprintk_store in the middle (after the call to
vsnprintf), and offer the second half as a function of its own (e.g.
"puts"). Then the tldr could be

- printk(msg);
+ puts(msg);
