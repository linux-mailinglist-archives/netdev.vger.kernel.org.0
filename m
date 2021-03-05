Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C668332E044
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhCEDpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:45:05 -0500
Received: from z11.mailgun.us ([104.130.96.11]:30684 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhCEDpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 22:45:04 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614915904; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=1XgWcuO8RRXhkwmZaJ1yekuLrhAw4v2umUDxFObNRXA=;
 b=cAfDTaDJVC04jvO6J4yAqwgbVZ421buMU6aAAT7RK+jxgBbi82h0u1EePZibmqbwp9YIXU4z
 tTwa9hc8OcJWSw1ToQH+oqPqlXo8Mb2k5mOnKn9tZQSOUEygxnfamEbh6ihqhkMtHMxJY9JM
 a/H171GW9pgpozxbaTLYMMzcL08=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 6041a939cb774affa936063f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 05 Mar 2021 03:44:57
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BD744C433ED; Fri,  5 Mar 2021 03:44:56 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E129BC433C6;
        Fri,  5 Mar 2021 03:44:54 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 04 Mar 2021 20:44:54 -0700
From:   subashab@codeaurora.org
To:     Alex Elder <elder@linaro.org>
Cc:     stranche@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] net: qualcomm: rmnet: stop using C
 bit-fields
In-Reply-To: <20210304223431.15045-1-elder@linaro.org>
References: <20210304223431.15045-1-elder@linaro.org>
Message-ID: <3a4a4c26494c12f9961c50e2d4b83c99@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-04 15:34, Alex Elder wrote:
> This series converts data structures defined in <linux/if_rmnet.h>
> so they use integral field values with bitfield masks rather than
> rely on C bit-fields.
> 
> I first proposed doing something like this long ago when my confusion
> about this code (and the memory layout it was supposed to represent)
> led me to believe it was erroneous:
>   
> https://lore.kernel.org/netdev/20190520135354.18628-1-elder@linaro.org/
> 
> It came up again recently, when Sharath Chandra Vurukala proposed
> a new structure in "if_rmnet.h", again using C bit-fields.  I asked
> whether the new structure could use field masks, and Jakub requested
> that this be done.
> 
> https://lore.kernel.org/netdev/1613079324-20166-1-git-send-email-sharathv@
> codeaurora.org/
> I volunteered to convert the existing RMNet code to use bitfield
> masks, and that is what I'm doing here.
> 
> The first three patches are more or less preparation work for the
> last three.
>   - The first marks two fields in an existing structure explicitly
>     big endian.  They are unused by current code, so this should
>     have no impact.
>   - The second simplifies some code that computes the value of a
>     field in a header in a somewhat obfuscated way.
>   - The third eliminates some trivial accessor macros, open-coding
>     them instead.  I believe the accessors actually do more harm
>     than good.
>   - The last three convert the structures defined in "if_rmnet.h"
>     so they are defined only with integral fields, each having
>     well-defined byte order.  Where sub-fields are needed, field
>     masks are defined so they can be encoded or extracted using
>     functions like be16_get_bits() or u8_encode_bits(), defined
>     in <linux/bitfield.h>.  The three structures converted are,
>     in order:  rmnet_map_header, rmnet_map_dl_csum_trailer, and
>     rmnet_map_ul_csum_header.
> 
> 					-Alex
> 
> Alex Elder (6):
>   net: qualcomm: rmnet: mark trailer field endianness
>   net: qualcomm: rmnet: simplify some byte order logic
>   net: qualcomm: rmnet: kill RMNET_MAP_GET_*() accessor macros
>   net: qualcomm: rmnet: use field masks instead of C bit-fields
>   net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum 
> trailer
>   net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header
> 
>  .../ethernet/qualcomm/rmnet/rmnet_handlers.c  | 11 ++--
>  .../net/ethernet/qualcomm/rmnet/rmnet_map.h   | 12 ----
>  .../qualcomm/rmnet/rmnet_map_command.c        | 11 +++-
>  .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 60 ++++++++---------
>  include/linux/if_rmnet.h                      | 65 +++++++++----------
>  5 files changed, 70 insertions(+), 89 deletions(-)

Can you share what all tests have been done with these patches
