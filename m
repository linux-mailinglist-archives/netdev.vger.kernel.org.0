Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 434707D2C4
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 03:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfHABVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 21:21:09 -0400
Received: from ozlabs.org ([203.11.71.1]:44055 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbfHABVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 21:21:09 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45zXYX3txyz9sDQ;
        Thu,  1 Aug 2019 11:21:04 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Nick Desaulniers <ndesaulniers@google.com>, kvalo@codeaurora.org,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH -next] iwlwifi: dbg: work around clang bug by marking debug strings static
In-Reply-To: <20190712001708.170259-1-ndesaulniers@google.com>
References: <20190712001708.170259-1-ndesaulniers@google.com>
Date:   Thu, 01 Aug 2019 11:21:01 +1000
Message-ID: <874l31r88y.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nick Desaulniers <ndesaulniers@google.com> writes:
> Commit r353569 in prerelease Clang-9 is producing a linkage failure:
>
> ld: drivers/net/wireless/intel/iwlwifi/fw/dbg.o:
> in function `_iwl_fw_dbg_apply_point':
> dbg.c:(.text+0x827a): undefined reference to `__compiletime_assert_2387'

This breakage is also seen in older GCC versions (v4.6.3 at least):

  drivers/net/wireless/intel/iwlwifi/fw/dbg.c: In function 'iwl_fw_dbg_info_apply.isra.10':
  drivers/net/wireless/intel/iwlwifi/fw/dbg.c:2445:3: error: call to '__compiletime_assert_2446' declared with attribute error: BUILD_BUG_ON failed: err_str[sizeof(err_str) - 2] != '\n'
  drivers/net/wireless/intel/iwlwifi/fw/dbg.c:2451:3: error: call to '__compiletime_assert_2452' declared with attribute error: BUILD_BUG_ON failed: err_str[sizeof(err_str) - 2] != '\n'
  drivers/net/wireless/intel/iwlwifi/fw/dbg.c: In function '_iwl_fw_dbg_apply_point':
  drivers/net/wireless/intel/iwlwifi/fw/dbg.c:2789:5: error: call to '__compiletime_assert_2790' declared with attribute error: BUILD_BUG_ON failed: invalid_ap_str[sizeof(invalid_ap_str) - 2] != '\n'
  drivers/net/wireless/intel/iwlwifi/fw/dbg.c:2800:5: error: call to '__compiletime_assert_2801' declared with attribute error: BUILD_BUG_ON failed: invalid_ap_str[sizeof(invalid_ap_str) - 2] != '\n'
 
  http://kisskb.ellerman.id.au/kisskb/buildresult/13902155/


Luca, you said this was already fixed in your internal tree, and the fix
would appear soon in next, but I don't see anything in linux-next?

cheers
