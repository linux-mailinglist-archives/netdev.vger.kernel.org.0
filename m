Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5AD522E5
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 07:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbfFYFhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 01:37:14 -0400
Received: from smtprelay0098.hostedemail.com ([216.40.44.98]:37100 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727064AbfFYFhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 01:37:13 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id B7673180A814F;
        Tue, 25 Jun 2019 05:37:10 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 
X-HE-Tag: toy89_3b5152c3463e
X-Filterd-Recvd-Size: 3596
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Tue, 25 Jun 2019 05:37:05 +0000 (UTC)
Message-ID: <c364c36338d385eba60c523828ad8995c792ae4d.camel@perches.com>
Subject: Re: [PATCH v4 5/7] lib/hexdump.c: Allow multiple groups to be
 separated by lines '|'
From:   Joe Perches <joe@perches.com>
To:     Alastair D'Silva <alastair@au1.ibm.com>, alastair@d-silva.org
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Andrew Morton <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Date:   Mon, 24 Jun 2019 22:37:03 -0700
In-Reply-To: <20190625031726.12173-6-alastair@au1.ibm.com>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
         <20190625031726.12173-6-alastair@au1.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-25 at 13:17 +1000, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> With the wider display format, it can become hard to identify how many
> bytes into the line you are looking at.
> 
> The patch adds new flags to hex_dump_to_buffer() and print_hex_dump() to
> print vertical lines to separate every N groups of bytes.
> 
> eg.
> buf:00000000: 454d414e 43415053|4e495f45 00584544  NAMESPAC|E_INDEX.
> buf:00000010: 00000000 00000002|00000000 00000000  ........|........
> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---
>  include/linux/printk.h |  3 +++
>  lib/hexdump.c          | 59 ++++++++++++++++++++++++++++++++++++------
>  2 files changed, 54 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/printk.h b/include/linux/printk.h
[]
> @@ -485,6 +485,9 @@ enum {
>  
>  #define HEXDUMP_ASCII			BIT(0)
>  #define HEXDUMP_SUPPRESS_REPEATED	BIT(1)
> +#define HEXDUMP_2_GRP_LINES		BIT(2)
> +#define HEXDUMP_4_GRP_LINES		BIT(3)
> +#define HEXDUMP_8_GRP_LINES		BIT(4)

These aren't really bits as only one value should be set
as 8 overrides 4 and 4 overrides 2.

I would also expect this to be a value of 2 in your above
example, rather than 8.  It's described as groups not bytes.

The example is showing a what would normally be a space ' '
separator as a vertical bar '|' every 2nd grouping.


