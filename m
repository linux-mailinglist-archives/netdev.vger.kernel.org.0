Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4955E69A336
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 01:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjBQA7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 19:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBQA67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 19:58:59 -0500
X-Greylist: delayed 25438 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Feb 2023 16:58:58 PST
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:1::99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6116497D2
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 16:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=mattcorallo.com; s=1676593262; h=In-Reply-To:From:References:Cc:To:Subject:
        From:Subject:To:Cc:Reply-To; bh=nRwXpmJGR9imDxQLdrhPGTOLuYmvt6Kd6cYKEqOPCo4=;
        b=AO1eiynFWLyu/7nz/fPgKGrKhRIX5zSuKOzDRQHK2JhuPebos77ubhRGfcUib96k6vws6M6OBk5
        ucy9pH0vJrW9Qi12zQ5x7jBOsKX8Du4q8xbjuHMchBNFW/mnzuKZcZKCToc+M4TZyMqKR1IRlv+Y9
        0erYE+wzvOl4TM/NYqeaiR5YyBvEI9fZT0hebvUlwaxARHqfLkF0GEOeIrSKeYrsYgOfdaeanuWge
        t+Kbt5bnMKvaRNKoyZk+D+B4cGLW3p9M8uyd+OTxd3zBEq/w/gmaU8VudjWkCcx2mpBjHf8tC8LG0
        Mot5LHAU1L14IeppQ6BcDtC2ZGqnHq0cJB/Q==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=clients.mail.as397444.net; s=1676593263; h=In-Reply-To:From:References:Cc:
        To:Subject:From:Subject:To:Cc:Reply-To;
        bh=nRwXpmJGR9imDxQLdrhPGTOLuYmvt6Kd6cYKEqOPCo4=; b=t48w1T6GGj59+K8TFif+KYz+/1
        t2Beng3ZKC/70VQTvE9lA3NfKTxBWlKjhtA9qTfEK8vAPvnoaaeqO7BdIUPVM7ZIW94+xkcKiEmyA
        Dt3MZISZGk0dRd60VTsvA6Wv31RrcC40H8a+moF/vZndEK04Kl8588cSOizOIV9pC7NtTUaf7nCZr
        nTkbZKl37hhu5PkGefhcxNXJ8lSme7Z486hTB1barjVYoCSYnxm2krjfRfNDYrugGAwh1QqQeKg+7
        W4eRu7jeIk1qQM55RwoG1fHGC0QejfDqHYeG6JnuweQ4pkM/w6CPZRvA1mJY2jKWgtNfRp4fWQ4DJ
        xSux48EA==;
Received: by mail.as397444.net with esmtpsa (TLS1.3) (Exim)
        (envelope-from <ntp-lists@mattcorallo.com>)
        id 1pSp5S-00AMqy-2S;
        Fri, 17 Feb 2023 00:58:54 +0000
Message-ID: <2c55f4ac-6b63-8648-e22f-8171a9f178dc@bluematt.me>
Date:   Thu, 16 Feb 2023 16:58:54 -0800
MIME-Version: 1.0
Subject: Re: [chrony-dev] Support for Multiple PPS Inputs on single PHC
Content-Language: en-US
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     chrony-dev@chrony.tuxfamily.org,
        Miroslav Lichvar <mlichvar@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <72ac9741-27f5-36a5-f64c-7d81008eebbc@bluematt.me>
 <Y+3m/PpzkBN9kxJY@localhost>
 <0fb552f0-b069-4641-a5c1-48529b56cdbf@bluematt.me>
 <Y+60JfLyQIXpSirG@hoboy.vegasvil.org>
From:   Matt Corallo <ntp-lists@mattcorallo.com>
In-Reply-To: <Y+60JfLyQIXpSirG@hoboy.vegasvil.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/mattcorallo.com
X-DKIM-Note: For more info, see https://as397444.net/dkim/
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/23 2:54 PM, Richard Cochran wrote:
> On Thu, Feb 16, 2023 at 09:54:56AM -0800, Matt Corallo wrote:
>> As for duplicating the output across sockets, ptp_chardev.c's `ptp_read` is
>> pretty trivial - just pop the next sample off the queue and return it.
>> Tweaking that to copy the sample into every reader is probably above my
>> paygrade (and has a whole host of leak risk I'd probably screw up).
>> `extts_fifo_show` appears to be functionally identical.
> 
> Each extts in the fifo is delivered only once.  If there are multiple
> readers, each reader will receive only some of the data.  This is
> similar to how a pipe behaves.

Right, sorry if the context wasn't clear, I only realized part of the message was removed in the 
first reply after sending. The question from Miroslav was, basically, "would kernel accept something 
to only get notified of extts pulses on a given channel, and, if so, how would we go about doing that".

The "we get pulses from all extts channels on the same socket" thing is a bit annoying to munge into 
chrony - it has the concept of "refclocks" which are a single clock, in this case a single pps pulse 
generator. If you have two of them on the same PTP clock but coming in on different pins/channels it 
doesn't have a way to express that outside of two refclocks. While we could take pulses from both 
refclocks on one socket and shove them into some queue and have the refclocks pick that data up its 
a bunch of complexity on the client side and not super clean in the current codebase.

Thanks,
Matt
