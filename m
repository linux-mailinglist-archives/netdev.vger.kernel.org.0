Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8084616E21
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 21:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbiKBUAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 16:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbiKBUAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 16:00:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D3114D10;
        Wed,  2 Nov 2022 12:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B279B8245B;
        Wed,  2 Nov 2022 19:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBD1C433C1;
        Wed,  2 Nov 2022 19:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667419139;
        bh=dPfcKIcOxG/XQ1fwM77g0SeXdU10zdJ5vDXPj710A2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fedhfv8p9FlTlJQ1ZyKmUoHOeU7TZM5gcJUvaMadd2wH1Mgv+Aisqj4SEYe1v+8YA
         viSvKcWq8ZwPPf5LUfVLcq1pc9gM77k//bMAllO1JsPMUcv0YrESbW/9d70Tmx4dP3
         8in8O0QAq4fhfqr1JeNAWiT5JlRP8Dra6riMHnHteWpopncqMJEMvfZrruX/tFTrZC
         gcxWTKckXXwYAw5z9b6Ubn6ZWH3SiNcs6WlgQzBbbl9Ed6R5BRnY2TrSP6vNjkegHz
         3H9zBwhoTYs/mKo4X/giNbs64Gj1q2DPcG5wNe/SukiTwto7N7e76PhWupxan9yBho
         avRCZQ38oue4A==
Date:   Wed, 2 Nov 2022 12:58:57 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/ctcm: Fix return type of ctc{mp,}m_tx()
Message-ID: <Y2LMAQMwno/NX536@dev-arch.thelio-3990X>
References: <20221102163252.49175-1-nathan@kernel.org>
 <Y2LJmr8gE2I7gOP5@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2LJmr8gE2I7gOP5@osiris>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiko,

On Wed, Nov 02, 2022 at 08:48:42PM +0100, Heiko Carstens wrote:
> On Wed, Nov 02, 2022 at 09:32:50AM -0700, Nathan Chancellor wrote:
> > should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.
> 
> Yes, s390 should select that :)
> 
> But, is there any switch or option I need to set when compiling clang,
> so it knows about the kcfi sanitizer?
> 
> I get:
> clang-16: error: unsupported option '-fsanitize=kcfi' for target 's390x-ibm-linux'
> 
> > clang --version
> clang version 16.0.0 (https://github.com/llvm/llvm-project.git e02110e2ab4dd71b276e887483f0e6e286d243ed)

No, kCFI is currently implemented in a target specific manner and Sami
only added AArch64 and X86 support in the initial change:

https://github.com/llvm/llvm-project/commit/cff5bef948c91e4919de8a5fb9765e0edc13f3de

He does have a generic version in progress but I assume it would not be
hard for one of your LLVM folks to add the kCFI operand bundle lowering
to the SystemZ backend to get access to it sooner (and it may allow for
a more optimized sequence of instructions if I understand correctly?):

https://reviews.llvm.org/D135411

Cheers,
Nathan
