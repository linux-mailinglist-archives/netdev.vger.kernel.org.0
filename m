Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 020F96B0E6
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 23:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388749AbfGPVPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 17:15:10 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:59204 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728781AbfGPVPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 17:15:09 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hnUmi-0000Yc-7k; Wed, 17 Jul 2019 00:14:54 +0300
Message-ID: <da053a97d771eff0ad8db37e644108ed2fad25a3.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Date:   Wed, 17 Jul 2019 00:14:49 +0300
In-Reply-To: <CAKwvOdkD_r2YBqRDy-uTGMG1YeRF8KokxjikR0XLkXLsdJca0g@mail.gmail.com>
References: <20190712001708.170259-1-ndesaulniers@google.com>
         <b219cf41933b2f965572af515cf9d3119293bfba.camel@perches.com>
         <CAKwvOdkD_r2YBqRDy-uTGMG1YeRF8KokxjikR0XLkXLsdJca0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        TVD_RCVD_IP,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.2
Subject: Re: [PATCH -next] iwlwifi: dbg: work around clang bug by marking
 debug strings static
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-07-16 at 10:28 -0700, Nick Desaulniers wrote:
> On Thu, Jul 11, 2019 at 7:15 PM Joe Perches <joe@perches.com> wrote:
> > On Thu, 2019-07-11 at 17:17 -0700, Nick Desaulniers wrote:
> > > Commit r353569 in prerelease Clang-9 is producing a linkage failure:
> > > 
> > > ld: drivers/net/wireless/intel/iwlwifi/fw/dbg.o:
> > > in function `_iwl_fw_dbg_apply_point':
> > > dbg.c:(.text+0x827a): undefined reference to `__compiletime_assert_2387'
> > > 
> > > when the following configs are enabled:
> > > - CONFIG_IWLWIFI
> > > - CONFIG_IWLMVM
> > > - CONFIG_KASAN
> > > 
> > > Work around the issue for now by marking the debug strings as `static`,
> > > which they probably should be any ways.
> > > 
> > > Link: https://bugs.llvm.org/show_bug.cgi?id=42580
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/580
> > > Reported-by: Arnd Bergmann <arnd@arndb.de>
> > > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > > ---
> > >  drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
> > > index e411ac98290d..f8c90ea4e9b4 100644
> > > --- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
> > > +++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
> > > @@ -2438,7 +2438,7 @@ static void iwl_fw_dbg_info_apply(struct iwl_fw_runtime *fwrt,
> > >  {
> > >       u32 img_name_len = le32_to_cpu(dbg_info->img_name_len);
> > >       u32 dbg_cfg_name_len = le32_to_cpu(dbg_info->dbg_cfg_name_len);
> > > -     const char err_str[] =
> > > +     static const char err_str[] =
> > >               "WRT: ext=%d. Invalid %s name length %d, expected %d\n";
> > 
> > Better still would be to use the format string directly
> > in both locations instead of trying to deduplicate it
> > via storing it into a separate pointer.
> > 
> > Let the compiler/linker consolidate the format.
> > It's smaller object code, allows format/argument verification,
> > and is simpler for humans to understand.
> 
> Whichever Kalle prefers, I just want my CI green again.

We already changed this in a later internal patch, which will reach the
mainline (-next) soon.  So let's skip this for now.

--
Cheers,
Luca.

