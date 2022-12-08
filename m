Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74FB647449
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiLHQ2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiLHQ22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:28:28 -0500
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 228BB10045
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:28:28 -0800 (PST)
Received: (qmail 731998 invoked by uid 1000); 8 Dec 2022 11:28:24 -0500
Date:   Thu, 8 Dec 2022 11:28:24 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Jungclaus <frank.jungclaus@esd.eu>, socketcan@esd.eu,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Stefan =?iso-8859-1?Q?M=E4tje?= <stefan.maetje@esd.eu>,
        Hangyu Hua <hbh25y@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Christoph =?iso-8859-1?Q?M=F6hring?= <cmoehring@christ-es.de>,
        John Whittington <git@jbrengineering.co.uk>,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Sebastian Haas <haas@ems-wuensche.com>,
        Maximilian Schneider <max@schneidersoft.net>,
        Daniel Berglund <db@kvaser.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        Remigiusz =?utf-8?B?S2/FgsWCxIV0YWo=?= 
        <remigiusz.kollataj@mobica.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Bernd Krumboeck <b.krumboeck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/8] can: usb: remove all usb_set_intfdata(intf, NULL) in
 drivers' disconnect()
Message-ID: <Y5IQqExJN9C9xQbF@rowland.harvard.edu>
References: <20221203133159.94414-1-mailhol.vincent@wanadoo.fr>
 <9493232b-c8fa-5612-fb13-fccf58b01942@suse.com>
 <CAMZ6RqJejJCOUk+MSvxjw9Us0gYhTuoOB4MUTk9jji6Bk=ix3A@mail.gmail.com>
 <b5df2262-7a4f-0dcf-6460-793dad02401d@suse.com>
 <CAMZ6RqL9eKco+fAMZoQ6X9PNE7dDK3KnFZoMCXrjgvx_ZU8=Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqL9eKco+fAMZoQ6X9PNE7dDK3KnFZoMCXrjgvx_ZU8=Ew@mail.gmail.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 12:44:51AM +0900, Vincent MAILHOL wrote:
> On Thu. 8 Dec. 2022 at 20:04, Oliver Neukum <oneukum@suse.com> wrote:

> > >> which is likely, then please also remove checks like this:
> > >>
> > >>          struct ems_usb *dev = usb_get_intfdata(intf);
> > >>
> > >>          usb_set_intfdata(intf, NULL);
> > >>
> > >>          if (dev) {
> >
> > Here. If you have a driver that uses usb_claim_interface().
> > You need this check or you unregister an already unregistered
> > netdev.
> 
> Sorry, but with all my best intentions, I still do not get it. During
> the second iteration, inft is NULL and:

No, intf is never NULL.  Rather, the driver-specific pointer stored in 
intfdata may be NULL.

You seem to be confusing intf with intfdata(intf).

>         /* equivalent to dev = intf->dev.data. Because intf is NULL,
>          * this is a NULL pointer dereference */
>         struct ems_usb *dev = usb_get_intfdata(intf);

So here dev will be NULL when the second interface's disconnect routine 
runs, because the first time through the routine sets the intfdata to 
NULL for both interfaces:

	USB core calls ->disconnect(intf1)

		disconnect routine sets intfdata(intf1) and 
		intfdata(intf2) both to NULL and handles the
		disconnection

	USB core calls ->disconnect(intf2)

		disconnect routine sees that intfdata(intf2) is
		already NULL, so it knows that it doesn't need
		to do anything more.

As you can see in this scenario, neither intf1 nor intf2 is ever NULL.

>         /* OK, intf is already NULL */
>         usb_set_intfdata(intf, NULL);
> 
>         /* follows a NULL pointer dereference so this is undefined
>          * behaviour */
>        if (dev) {
> 
> How is this a valid check that you entered the function for the second
> time? If intf is the flag, you should check intf, not dev? Something
> like this:

intf is not a flag; it is the argument to the function and is never 
NULL.  The flag is the intfdata.

>         struct ems_usb *dev;
> 
>         if (!intf)
>                 return;
> 
>         dev = usb_get_intfdata(intf);
>         /* ... */
> 
> I just can not see the connection between intf being NULL and the if
> (dev) check. All I see is some undefined behaviour, sorry.

Once you get it straightened out in your head, you will understand.

Alan Stern
