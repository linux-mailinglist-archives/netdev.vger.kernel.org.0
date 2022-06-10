Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6803545F46
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 10:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347676AbiFJIeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 04:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347743AbiFJIeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 04:34:22 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2091EC7F;
        Fri, 10 Jun 2022 01:32:14 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 43D6D5872870F; Fri, 10 Jun 2022 10:32:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 4326A60C247DA;
        Fri, 10 Jun 2022 10:32:13 +0200 (CEST)
Date:   Fri, 10 Jun 2022 10:32:13 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     David Laight <David.Laight@ACULAB.COM>
cc:     'Bill Wendling' <morbo@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        Networking <netdev@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        clang-built-linux <llvm@lists.linux.dev>
Subject: RE: [PATCH 00/12] Clang -Wformat warning fixes
In-Reply-To: <01da36bfd13e421aadb2eff661e7a959@AcuMS.aculab.com>
Message-ID: <o5496n8r-451p-751-3258-97112opns7s8@vanv.qr>
References: <20220609221702.347522-1-morbo@google.com> <20220609152527.4ad7862d4126e276e6f76315@linux-foundation.org> <CAGG=3QXDt9AeCQOAp1311POFRSByJru4=Q=oFiQn3u2iZYk2_w@mail.gmail.com> <01da36bfd13e421aadb2eff661e7a959@AcuMS.aculab.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Friday 2022-06-10 10:17, David Laight wrote:
>> 
>> Calling a "printf" style function is already insanely expensive. :-) I
>> understand that it's not okay blithely to increase runtime resources
>> simply because it's already slow, but in this case it's worthwhile.
>
>Yep, IMHO definitely should be fixed.
>It is even possible that using "%s" is faster because the printf
>code doesn't have to scan the string for format effectors.

I see no special handling; the vsnprintf function just loops
over fmt as usual and I see no special casing of fmt by
e.g. strcmp(fmt, "%s") == 0 to take a shortcut.
