Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3BB17EC09
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgCIW2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:28:13 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:58672 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726937AbgCIW2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 18:28:13 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4900E80064;
        Mon,  9 Mar 2020 22:28:11 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 9 Mar 2020
 22:28:02 +0000
Subject: Re: [patch net-next v4 01/10] flow_offload: Introduce offload of HW
 stats type
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <saeedm@mellanox.com>, <leon@kernel.org>,
        <michael.chan@broadcom.com>, <vishal@chelsio.com>,
        <jeffrey.t.kirsher@intel.com>, <idosch@mellanox.com>,
        <aelior@marvell.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <pablo@netfilter.org>,
        <mlxsw@mellanox.com>
References: <20200307114020.8664-1-jiri@resnulli.us>
 <20200307114020.8664-2-jiri@resnulli.us>
 <1b7ddf97-5626-e58c-0468-eae83ad020b3@solarflare.com>
 <20200309143630.2f83476f@kicinski-fedora-PC1C0HJN>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <75b7e941-9a94-9939-f212-03aaed856088@solarflare.com>
Date:   Mon, 9 Mar 2020 22:27:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200309143630.2f83476f@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25278.003
X-TM-AS-Result: No-8.351700-8.000000-10
X-TMASE-MatchedRID: y/2oPz6gbvjmLzc6AOD8DfHkpkyUphL9TJDl9FKHbrniYlKox3ryNHvi
        bgiOTC8xqAiL+D9B+Br2HzBcIEM+5hTHv6/BqiT5xcDvxm0Uv+D4h+uI7dxXxMM5LQWFwBdKmyO
        EHYu8lL86My7S7lLKD8IQKoMiDOBSWDyZi9SR6PME/Kog5XZV2wILzOoe9wbay5JfHvVu9IsJ3+
        SWYfjBlRlxQ66UeFhTLsOyjR5rXS+Eh/yg/+0EYKOknopQLzTu4lzqEpaPQLUKQo6lRC5cFf6RO
        KSr3u5/TmTITP82A2EjP6dYvGOnvjBoPsIJ2P3p4h8r8l3l4eZ9LQinZ4QefNZE3xJMmmXc+gtH
        j7OwNO2I9t8DSRevIci7djx0PUIiN/RXQYtL8jOVHyPdMZUczbq7wXpmX5BaVlxr1FJij9s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.351700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25278.003
X-MDID: 1583792892-AZbMJmycNLli
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/03/2020 21:36, Jakub Kicinski wrote:
> ...but using the type for fields which are very likely to contain
> values from outside of the enumeration seems confusing, IMHO.
It's the only way I can see to (a) ensure that the field is the correct
 size and (b) document the connection between the field and the type.

Now, I'm not saying that using the enums actually buys any real type-
 safety — the C standard enums are far too weak for that, being
 basically ints with hair — but the mythical Sufficiently Smart
 Compiler might be able to get some mileage out of it to issue better
 diagnostics.

> Driver author can understandably try to simply handle all the values 
> in a switch statement and be unpleasantly surprised.
In my experience, unenumerated enum values of this kind are fully
 idiomatic C; and a driver author looking at the header file to see
 what enumeration constants are defined will necessarily see all the
 calls to BIT() and the bitwise-or construction of _ANY.
I'm not sure I believe a naïve switch() implementation is an
 "understandable" error.

How about if we also rename the field "hw_stats_types", or squeeze
 the word "mask" in there somewhere?

-ed
