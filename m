Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3D5FC3674
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 15:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388902AbfJAN5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 09:57:11 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34512 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388856AbfJAN5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 09:57:11 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iFIeI-0001pX-G2; Tue, 01 Oct 2019 15:57:06 +0200
Message-ID: <9bbf73e318df17d179014937cb6c1335fb303611.camel@sipsolutions.net>
Subject: Re: [PATCH net v4 01/12] net: core: limit nested device depth
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?Q?Ji=C5=99=C3=AD_P=C3=ADrko?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cody Schuffelen <schuffelen@google.com>, bjorn@mork.no
Date:   Tue, 01 Oct 2019 15:57:05 +0200
In-Reply-To: <CAMArcTW6q=ga1juv_Qp-dKwRwxneAEsX4xQxN-n19oWM-VUQ+w@mail.gmail.com> (sfid-20191001_155348_267769_C0F821E2)
References: <20190928164843.31800-1-ap420073@gmail.com>
         <20190928164843.31800-2-ap420073@gmail.com>
         <d1b5d944fef2a2d5875a0f12f3cdc490586da475.camel@sipsolutions.net>
         <CAMArcTUgcPv+kg5rhw0i2iwX-CiD00v3ZCvw0b_Q0jb_-eo=UQ@mail.gmail.com>
         <39e879f59ad3b219901839d1511fc96886bf94fb.camel@sipsolutions.net>
         <CAMArcTW6q=ga1juv_Qp-dKwRwxneAEsX4xQxN-n19oWM-VUQ+w@mail.gmail.com>
         (sfid-20191001_155348_267769_C0F821E2)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

(jumping out now, forgive me for being so brief)

> If I understand correctly, you said about the alignment of
> "lower_level" and "upper_level".
> I thought this place is a fine position for variables as regards the
> alignment and I didn't try to put each variable in different places.
> 
> If I misunderstood your mention, please let me know.

Not sure what you mean, alignment doesn't matter for them (they're u8).

I was thinking of the packing for the overall struct, we have:

        unsigned int            max_mtu;
        unsigned short          type;
        unsigned short          hard_header_len;
        unsigned char           min_header_len;

+	unsigned char		upper_level, lower_level;

        unsigned short          needed_headroom;
        unsigned short          needed_tailroom;


Previously, there was a one byte hole at that spot due to a single
"unsigned char" (after something aligned at least 4 bytes) followed by
"unsigned short" - now you push that out a bit.

If you place the variables a bit lower, below "name_assign_type", you
probably fill a hole instead.

Check out the 'pahole' tool.

johannes

