Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CA9311106
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 20:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhBERjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 12:39:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39402 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233435AbhBEP5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 10:57:23 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1l854C-0003cO-Bn; Fri, 05 Feb 2021 17:38:48 +0000
To:     Johannes Berg <johannes.berg@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: Potential invalid ~ operator in net/mac80211/cfg.c
Message-ID: <4bb65f2f-48f9-7d9c-ab2e-15596f15a4d8@canonical.com>
Date:   Fri, 5 Feb 2021 17:38:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there,

while working through a backlog of older static analysis reports from
Coverity I found an interesting use of the ~ operator that looks
incorrect to me in function ieee80211_set_bitrate_mask():

                for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++) {
                        if (~sdata->rc_rateidx_mcs_mask[i][j]) {
                                sdata->rc_has_mcs_mask[i] = true;
                                break;
                        }
                }

                for (j = 0; j < NL80211_VHT_NSS_MAX; j++) {
                        if (~sdata->rc_rateidx_vht_mcs_mask[i][j]) {
                                sdata->rc_has_vht_mcs_mask[i] = true;
                                break;
                        }
                }

For the ~ operator in both if stanzas, Coverity reports:

Logical vs. bitwise operator (CONSTANT_EXPRESSION_RESULT)
logical_vs_bitwise:

~sdata->rc_rateidx_mcs_mask[i][j] is always 1/true regardless of the
values of its operand. This occurs as the logical operand of if.
    Did you intend to use ! rather than ~?

I've checked the results of this and it does seem that ~ is incorrect
and always returns true for the if expression. So it probably should be
!, but I'm not sure if I'm missing something deeper here and wondering
why this has always worked.

Colin
