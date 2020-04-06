Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1299819F5F9
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgDFMoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 08:44:21 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:57804 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbgDFMoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 08:44:21 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jLR6j-009kcZ-Dx; Mon, 06 Apr 2020 14:44:05 +0200
Message-ID: <f2a393a2f01c93776446c83e345a102a780cfe88.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix race in ieee80211_register_hw()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sumit Garg <sumit.garg@linaro.org>, linux-wireless@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthias.schoepfer@ithinx.io,
        Philipp.Berg@liebherr.com, Michael.Weitner@liebherr.com,
        daniel.thompson@linaro.org, loic.poulain@linaro.org,
        stable@vger.kernel.org
Date:   Mon, 06 Apr 2020 14:44:02 +0200
In-Reply-To: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org> (sfid-20200406_142251_569735_E1B08414)
References: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org>
         (sfid-20200406_142251_569735_E1B08414)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-04-06 at 17:51 +0530, Sumit Garg wrote:
> A race condition leading to a kernel crash is observed during invocation
> of ieee80211_register_hw() on a dragonboard410c device having wcn36xx
> driver built as a loadable module along with a wifi manager in user-space
> waiting for a wifi device (wlanX) to be active.
> 
> Sequence diagram for a particular kernel crash scenario:
> 
>     user-space  ieee80211_register_hw()  RX IRQ
>     +++++++++++++++++++++++++++++++++++++++++++++
>        |                    |             |
>        |<---wlan0---wiphy_register()      |
>        |----start wlan0---->|             |
>        |                    |<---IRQ---(RX packet)
>        |              Kernel crash        |
>        |              due to unallocated  |
>        |              workqueue.          |
>        |                    |             |
>        |       alloc_ordered_workqueue()  |
>        |                    |             |
>        |              Misc wiphy init.    |
>        |                    |             |
>        |            ieee80211_if_add()    |
>        |                    |             |
> 
> As evident from above sequence diagram, this race condition isn't specific
> to a particular wifi driver but rather the initialization sequence in
> ieee80211_register_hw() needs to be fixed. 

Indeed, oops.

> So re-order the initialization
> sequence and the updated sequence diagram would look like:
> 
>     user-space  ieee80211_register_hw()  RX IRQ
>     +++++++++++++++++++++++++++++++++++++++++++++
>        |                    |             |
>        |       alloc_ordered_workqueue()  |
>        |                    |             |
>        |              Misc wiphy init.    |
>        |                    |             |
>        |<---wlan0---wiphy_register()      |
>        |----start wlan0---->|             |
>        |                    |<---IRQ---(RX packet)
>        |                    |             |
>        |            ieee80211_if_add()    |
>        |                    |             |

Makes sense.

> @@ -1254,6 +1250,14 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  		local->sband_allocated |= BIT(band);
>  	}
>  
> +	rtnl_unlock();
> +
> +	result = wiphy_register(local->hw.wiphy);
> +	if (result < 0)
> +		goto fail_wiphy_register;
> +
> +	rtnl_lock();

I'm a bit worried about this unlock/relock here though.

I think we only need the RTNL for the call to
ieee80211_init_rate_ctrl_alg() and then later ieee80211_if_add(), so
perhaps we can move that a little closer?

All the stuff between is really just setting up local stuff, so doesn't
really need to worry?

johannes


