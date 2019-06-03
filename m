Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8E533998
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 22:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfFCUOT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Jun 2019 16:14:19 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38381 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfFCUOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 16:14:18 -0400
Received: by mail-ed1-f66.google.com with SMTP id g13so28584873edu.5
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 13:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Q2/9moJbjndV1cW6Hj1XANq+vkkmQEi9E4FRdRIySFs=;
        b=hSHsL1kblOPjYjrTe6DRzocOk5x4NR/lv5XOU705mxfu2DxWVbNliqq+/tQW19qtnn
         EbzPD1U3Nz3zS+4Rl8pKY1fv9bf+H4xAxFFah9jql438SmcPyDKcaJWb0D8KyrKj/uoL
         AB3f9lVhUpTwbcUSX6hA0ENFphMiOopMu2CVSDRdtlsPqLMQ9FSvQsBUEHkrYHdJ02fv
         wN9COogppmnlXK7qAbCBCkjecKx5wuMrBFRAg6QQQl4IgsuNfS9fht9q/mw/zszVxRs+
         bIN/UVHYMnlLhKZUVvwuEPnk37JzEpIlUW9f+8742KhA5z8gdNMbM/xxq3mfZybfzEZf
         sGZQ==
X-Gm-Message-State: APjAAAUvFL8wHQYJTQNpHGs1voII5R8uInAO5f+VEbPRIABsqlBi/yqs
        ff37zATeACwbHjBgnH4TyHYmXg==
X-Google-Smtp-Source: APXvYqwXMLjpPY35oIs90KmRdY/aELDtTmvmotSFs8zdoB/3zHsgw6Dt0LWd7AggGk2THaiXX2Wzog==
X-Received: by 2002:a17:906:30c3:: with SMTP id b3mr25499572ejb.153.1559592856626;
        Mon, 03 Jun 2019 13:14:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id o11sm2291884edh.30.2019.06.03.13.14.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 13:14:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3565D1800F7; Mon,  3 Jun 2019 22:14:15 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        ldir@darbyshire-bryant.me.uk
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
Subject: Re: [PATCH RFC iproute2-next v4] tc: add support for action act_ctinfo
In-Reply-To: <20190603135040.75408-1-ldir@darbyshire-bryant.me.uk>
References: <20190602185020.40787-1-ldir@darbyshire-bryant.me.uk> <20190603135040.75408-1-ldir@darbyshire-bryant.me.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 03 Jun 2019 22:14:15 +0200
Message-ID: <87y32ifmug.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> writes:

> ctinfo is an action restoring data stored in conntrack marks to various
> fields.  At present it has two independent modes of operation,
> restoration of DSCP into IPv4/v6 diffserv and restoration of conntrack
> marks into packet skb marks.
>
> It understands a number of parameters specific to this action in
> additional to the usual action syntax.  Each operating mode is
> independent of the other so all options are optional, however not
> specifying at least one mode is a bit pointless.
>
> Usage: ... ctinfo [dscp mask [statemask]] [cpmark [mask]] [zone ZONE]
> 		  [CONTROL] [index <INDEX>]
>
> DSCP mode
>
> dscp enables copying of a DSCP store in the conntrack mark into the
> ipv4/v6 diffserv field.  The mask is a 32bit field and specifies where
> in the conntrack mark the DSCP value is stored.  It must be 6 contiguous
> bits long, e.g. 0xfc000000 would restore the DSCP from the upper 6 bits
> of the conntrack mark.
>
> The DSCP copying may be optionally controlled by a statemask.  The
> statemask is a 32bit field, usually with a single bit set and must not
> overlap the dscp mask.  The DSCP restore operation will only take place
> if the corresponding bit/s in conntrack mark yield a non zero result.
>
> eg. dscp 0xfc000000/0x01000000 would retrieve the DSCP from the top 6
> bits, whilst using bit 25 as a flag to do so.  Bit 26 is unused in this
> example.
>
> CPMARK mode
>
> cpmark enables copying of the conntrack mark to the packet skb mark.  In
> this mode it is completely equivalent to the existing act_connmark.
> Additional functionality is provided by the optional mask parameter,
> whereby the stored conntrack mark is logically anded with the cpmark
> mask before being stored into skb mark.  This allows shared usage of the
> conntrack mark between applications.
>
> eg. cpmark 0x00ffffff would restore only the lower 24 bits of the
> conntrack mark, thus may be useful in the event that the upper 8 bits
> are used by the DSCP function.
>
> Usage: ... ctinfo [dscp mask [statemask]] [cpmark [mask]] [zone ZONE]
> 		  [CONTROL] [index <INDEX>]
> where :
> 	dscp MASK is the bitmask to restore DSCP
> 	     STATEMASK is the bitmask to determine conditional restoring
> 	cpmark MASK mask applied to restored packet mark
> 	ZONE is the conntrack zone
> 	CONTROL := reclassify | pipe | drop | continue | ok |
> 		   goto chain <CHAIN_INDEX>
>
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
>
> ---
> v2 - fix whitespace issue in pkt_cls
>      fix most warnings from checkpatch - some lines still over 80 chars
>      due to long TLV names.
> v3 - fix some dangling else warnings.
>      refactor stats printing to please checkpatch.
>      send zone TLV even if default '0' zone.
>      now checkpatch clean even though I think some of the formatting
>      is horrible :-)
>      sending via google's smtp 'cos MS' exchange office365 appears
>      to mangle patches from git send-email.
> v4 - use the NEXT_ARG macros throughout.
>      fix printing typo use 'cpmark' instead of 'mark'.
>      use space separator between dscp mask & optional statemask and
>      update usage as a result.
>      validate dscp mask & statemask and print friendlier warnings
>      than "invalid".
>      fix cpmark option default value handling bug.

No further comments on this version; you should probably re-submit
without the RFC tag, though.

Feel free to add my

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>

when you do...

-Toke
