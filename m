Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45CC678AAA
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbjAWWUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjAWWUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:20:33 -0500
Received: from mx11lb.world4you.com (mx11lb.world4you.com [81.19.149.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173D713DD0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/WFLWBP+4tZFE2Gi38AS4tQrm+5RzANnXTm34Kd5ZGQ=; b=gRiZ9zIdXo83RnJ7H9iktcQU0u
        sLpJnD4F/JCJAr4LXt+UaPeqkeYRXnLdXrasE/1YV6CiUA0IanmADV3I9JLU0oNyjro1y2n5IJSLA
        6I5gNVSXg17VqNjPT24asRb0DsWPoI3tjv5NHw8UBXMNTmUHBA04l+jtel03U5nLNpG8=;
Received: from [88.117.49.184] (helo=[10.0.0.160])
        by mx11lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pK5Ay-0007oa-Qv; Mon, 23 Jan 2023 23:20:28 +0100
Message-ID: <2d932e4d-6f4b-c6f6-3e14-d7d98d4f5b71@engleder-embedded.com>
Date:   Mon, 23 Jan 2023 23:20:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC PATCH net-next 00/11] ENETC mqprio/taprio cleanup
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
 <3e324602-a33a-b243-80db-6f6077ca5029@engleder-embedded.com>
 <20230123213144.jixdztjnut4tnf6r@skbuf>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20230123213144.jixdztjnut4tnf6r@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.01.23 22:31, Vladimir Oltean wrote:
> On Mon, Jan 23, 2023 at 10:21:33PM +0100, Gerhard Engleder wrote:
>> For my tsnep IP core it is similar, but with reverse priority. TXQ 0 has
>> the lowest priority (to be used for none real-time traffic). TXQ 1 has
>> priority over TXQ 0, TXQ 2 has priority over TXQ 1, ... . The number of
>> TX queues is flexible and depends on the requirements of the real-time
>> application and the available resources within the FPGA. The priority is
>> hard coded to save FPGA resources.
> 
> But if there's no round robin between queues of equal priority, it means
> you can never have more than 1 TXQ per traffic class with this design,
> or i.o.w., your best-effort traffic will always be single queue, right?

Yes, with the current design only 1 TXQ per traffic class is the goal.

>>> Furthermore (and this is really the biggest point of contention), myself
>>> and Vinicius have the fundamental disagreement whether the 802.1Qbv
>>> (taprio) gate mask should be passed to the device driver per TXQ or per
>>> TC. This is what patch 11/11 is about.
>>
>> tsnep also expects gate mask per TXQ. This simplifies the hardware
>> implementation. But it would be no problem if the gate mask would be
>> passed per TC and the driver is able to transform it to per TXQ.
> 
> If tsnep can only have at most 1 TXQ per TC, then what's the difference
> between gate mask per TXQ and gate mask per TC?

There can be less TCs than TXQs. If only the second TXQ would be used,
then gate mask per TC would be 0x1 and gate mask per TXQ would be 0x2.

If number of TCs and TXQs would be identical, then there would be no
difference. The overlap check enforces that TXQs are assigned to TCs in
strict order. So TXQs cannot be assigned to TCs in arbitrary order. At
least that was the result of a quick test. But I don't know what's the
reason of this behavior.

Gerhard
