Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9896710B065
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 14:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfK0NiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 08:38:18 -0500
Received: from a27-188.smtp-out.us-west-2.amazonses.com ([54.240.27.188]:44674
        "EHLO a27-188.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726603AbfK0NiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 08:38:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574861896;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=mgZ3qLyqFDIHRZs3m2gwVQuR1D8c5mwT+hdMMXCxQnM=;
        b=GvXHQ3T3o9ZJWmGp42rf/EdehLEz0A8BaW0cVXXQ/FG2+3OrYvK5r8+QX4kQBA1B
        35ETq0PEWu3ngMF/kUsC1qYujz0bOMAV7GxQKAot0IQfYakPWcdg5Zzb9xJpyZKj9qw
        5rTcRU4Xx1RwtVQqEO2XvGtopYayKzZTqSb5xLlY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574861896;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=mgZ3qLyqFDIHRZs3m2gwVQuR1D8c5mwT+hdMMXCxQnM=;
        b=Zqvmbscz5R552+gm0tLz2qBL+cPF8W5rvxn1LwrPATYke0asvYWcdaAPAvosnplQ
        ta3ck1IRsEnTNIPxB1TcFA3HPsU5zrzpsyrVZyTObaVKWRiJkRcfrk3njb3tHIO0kSr
        rQKUBzn2X7DSWXo4tB4lWEdyoUVMlDPiTQkIDs5g=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 419B7C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
Cc:     Alexander Lobakin <alobakin@dlink.ru>,
        Luciano Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Manish Chopra <manishc@marvell.com>,
        "GR-Linux-NIC-Dev\@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "Kenneth R. Crudup" <kenny@panix.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: wireless: intel: iwlwifi: fix GRO_NORMAL packet stalling
References: <20191127094123.18161-1-alobakin@dlink.ru>
        <7a9332bf645fbb8c9fff634a3640c092fb9b4b79.camel@intel.com>
        <c571a88c15c4a70a61cde6ca270af033@dlink.ru>
        <PSXP216MB0438B2F163C635F8B8B4AD8AA4440@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
        <a638ab877999dbc4ded87bfaebe784f5@dlink.ru>
        <PSXP216MB04382F0BA8CE3754439EA2CC80440@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
Date:   Wed, 27 Nov 2019 13:38:16 +0000
In-Reply-To: <PSXP216MB04382F0BA8CE3754439EA2CC80440@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
        (Nicholas Johnson's message of "Wed, 27 Nov 2019 11:16:21 +0000")
Message-ID: <0101016ead157ba1-af7ef42c-fb93-4a85-97bd-576072a699fc-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.11.27-54.240.27.188
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au> writes:

> On Wed, Nov 27, 2019 at 01:29:03PM +0300, Alexander Lobakin wrote:
>> Nicholas Johnson wrote 27.11.2019 13:23:
>> > Hi,
>> 
>> Hi Nicholas,
>> 
>> >  Sorry for top down reply, stuck with my phone. If it replies HTML
>> > then I am so done with Outlook client.
>
> I am very sorry to everybody for the improper reply. It looks like it 
> was HTML as vger.kernel.org told me I was spam. If anybody knows a good 
> email client for kernel development for Android then I am all ears.

I use K-9 Mail because Greg K-H used it :) TBH I use it mostly only for
reading but seems to work quite well:

https://k9mail.github.io

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
