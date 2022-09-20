Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D5E5BE9CD
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiITPOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiITPOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:14:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3233ED7A;
        Tue, 20 Sep 2022 08:14:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 429F0B82028;
        Tue, 20 Sep 2022 15:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D09C433C1;
        Tue, 20 Sep 2022 15:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663686842;
        bh=pjUFPROfrsBivzzwFMzntYSBLyxNj0LcihqzEYOuZa8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E5/Jj0nHZ+EN8964yg6WHW9lnxNvX32DRxrc5mFsoPiPD28R4QF2+tyEOoPw85MtV
         XpAjdTJYWe4aVlxfCdwm1iFBMdBFh3RMcY8vOHvEftYHcb7B8LdJEDzMwpgf8edIli
         8roQsJIwT4eihWzQJftczG2s90cJJbCT8LwnJicX6jkLvIIh7ygeYEZ6QqeZs66/By
         3/yoXm2ksRlCGjnbzxQfyIa2pDvi7+ruNJhHQBWA6qzJ4UcWbXHqDZVmESitLNEV4p
         n4dcle8c849b0y2vVDwMv1TtaBbre5EIsgJoOfjZCSaFOyF5eWGoO2x0ZllybxjaxZ
         wFJoAOP+DXA4w==
Date:   Tue, 20 Sep 2022 08:14:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: ipa: properly limit modem routing table use
Message-ID: <20220920081400.0cbe44ff@kernel.org>
In-Reply-To: <20220913204602.1803004-1-elder@linaro.org>
References: <20220913204602.1803004-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Sep 2022 15:46:02 -0500 Alex Elder wrote:
> IPA can route packets between IPA-connected entities.  The AP and
> modem are currently the only such entities supported, and no routing
> is required to transfer packets between them.
> 
> The number of entries in each routing table is fixed, and defined at
> initialization time.  Some of these entries are designated for use
> by the modem, and the rest are available for the AP to use.  The AP
> sends a QMI message to the modem which describes (among other
> things) information about routing table memory available for the
> modem to use.
> 
> Currently the QMI initialization packet gives wrong information in
> its description of routing tables.  What *should* be supplied is the
> maximum index that the modem can use for the routing table memory
> located at a given location.  The current code instead supplies the
> total *number* of routing table entries.  Furthermore, the modem is
> granted the entire table, not just the subset it's supposed to use.
> 
> This patch fixes this.  First, the ipa_mem_bounds structure is
> generalized so its "end" field can be interpreted either as a final
> byte offset, or a final array index.  Second, the IPv4 and IPv6
> (non-hashed and hashed) table information fields in the QMI
> ipa_init_modem_driver_req structure are changed to be ipa_mem_bounds
> rather than ipa_mem_array structures.  Third, we set the "end" value
> for each routing table to be the last index, rather than setting the
> "count" to be the number of indices.  Finally, instead of allowing
> the modem to use all of a routing table's memory, it is limited to
> just the portion meant to be used by the modem.  In all versions of
> IPA currently supported, that is IPA_ROUTE_MODEM_COUNT (8) entries.
> 
> Update a few comments for clarity.
> 
> Fixes: 530f9216a9537 ("soc: qcom: ipa: AP/modem communications")
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
> v2: Update the element info arrays defining the modified QMI message
>     so it uses the ipa_mem_bounds_ei structure rather than the
>     ipa_mem_array_ei structure.  The message format is identical,
>     but the code was incorrect without that change.

Unclear to me why, ipa_mem_bounds_ei and ipa_mem_array_ei seem
identical, other than s/end/count/. Overall the patch feels 
a touch too verbose for a fix, makes it harder to grasp the key
functional change IMHO. I could be misunderstanding but please
keep the goal of making fixes small and crisp in mind for the future.
