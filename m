Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4414B1BCD
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 03:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347120AbiBKCBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 21:01:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344360AbiBKCBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 21:01:42 -0500
X-Greylist: delayed 442 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Feb 2022 18:01:42 PST
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 5ED4D5FA7
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 18:01:42 -0800 (PST)
Received: (qmail 620042 invoked by uid 1000); 10 Feb 2022 20:54:19 -0500
Date:   Thu, 10 Feb 2022 20:54:19 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Hans Petter Selasky <hps@selasky.org>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC] CDC-NCM: avoid overflow in sanity checking
Message-ID: <YgXByzVayvl3KJTS@rowland.harvard.edu>
References: <20220210155455.4601-1-oneukum@suse.com>
 <a9143724-51ca-08ea-588c-b849a4ba7011@selasky.org>
 <87v8xmocng.fsf@miraculix.mork.no>
 <3624a7e7-3568-bee1-77e5-67d5b7d48aa6@selasky.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3624a7e7-3568-bee1-77e5-67d5b7d48aa6@selasky.org>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 11:50:20PM +0100, Hans Petter Selasky wrote:
> On 2/10/22 18:27, Bjørn Mork wrote:
> > Hans Petter Selasky <hps@selasky.org> writes:
> > 
> > > "int" variables are 32-bit, so 0xFFF0 won't overflow.
> > > 
> > > The initial driver code written by me did only support 16-bit lengths
> > > and offset. Then integer overflow is not possible.
> > > 
> > > It looks like somebody else introduced this integer overflow :-(
> > > 
> > > commit 0fa81b304a7973a499f844176ca031109487dd31
> > > Author: Alexander Bersenev <bay@hackerdom.ru>
> > > Date:   Fri Mar 6 01:33:16 2020 +0500
> > > 
> > >      cdc_ncm: Implement the 32-bit version of NCM Transfer Block
> > > 
> > >      The NCM specification defines two formats of transfer blocks: with
> > >      16-bit
> > >      fields (NTB-16) and with 32-bit fields (NTB-32). Currently only
> > >      NTB-16 is
> > >      implemented.
> > > 
> > > ....
> > > 
> > > With NCM 32, both "len" and "offset" must be checked, because these
> > > are now 32-bit and stored into regular "int".
> > > 
> > > The fix you propose is not fully correct!
> > 
> > Yes, there is still an issue if len > skb_in->len since
> > (skb_in->len - len) then ends up as a very large unsigned int.
> > 
> > I must admit that I have some problems tweaking my mind around these
> > subtle unsigned overflow thingies.  Which is why I suggest just
> > simplifying the whole thing with an additional test for the 32bit case
> > (which never will be used for any sane device):
> > 
> > 		} else {
> > 			offset = le32_to_cpu(dpe.dpe32->dwDatagramIndex);
> > 			len = le32_to_cpu(dpe.dpe32->dwDatagramLength);
> >                          if (offset < 0 || len < 0)
> >                                  goto err_ndp;
> > 		}
> 
> Hi,
> 
> I think something like this would do the trick:
> 
> if (offset < 0 || offset > sbk_in->len ||
>     len < 0 || len > sbk_in->len)

Speaking as someone who is entirely unfamiliar with this code, a few
things seem clear.

First, since offset and len are initialized by converting 16- or 32-bit 
unsigned values from little-endian to cpu-endian, they should be 
unsigned themselves.

Second, once they are unsigned there is obviously no point in testing 
whether they are < 0.

Third, if you want to make sure that skb_in's buffer contains the entire 
interval from offset to offset + len, the proper tests are:

	if (offset <= skb_in->len && len <= skb_in->len - offset) ...

The first test demonstrates that the start of the interval is in range 
and the second test demonstrates that the end of the interval is in 
range.  Furthermore, success of the first test proves that the 
computation in the second test can't overflow to a negative value.

IMO, working with unsigned values is simpler than working with 
signed values.  But it does require some discipline to ensure that 
intermediate computations don't overflow or yield negative values.

Alan Stern
