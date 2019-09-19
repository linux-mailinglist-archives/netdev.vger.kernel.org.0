Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6589B7E4C
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 17:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389838AbfISPg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 11:36:27 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:32997 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728720AbfISPg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 11:36:26 -0400
Received: by mail-ed1-f49.google.com with SMTP id c4so3652174edl.0
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 08:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=c5fDiX3zbTamI1qqbp2re4XV73zDzkQMbszKWk9pl4w=;
        b=UZD5fiwToYxZl5/F/FwodVJDfE12HuG0qNJ3h2jGh1oeX4Dapo/EN/cW207V8UquCq
         cjaw/NXmntmkt525++Ae/NckmCbIMNAT8r0wluTqpYHObKcU2Hlxo+Oc5pz5lN96jECg
         rifYHuSrxQ/gWhAOhkYklITwBGOLXF+gqXkR1J/in4fia04egF73j5UGeX6ESUjO9WqS
         WYkWsKedcIe/dooLIOxtDjeKcMIVI1BTYPozloW27FIpi8a1yN2+fm2L/w1x2300hwYR
         G99hXWqA8CenBCyDFEqx8ORfLPN5Jo1lx6NTeiNN5ns01EhhNMo15gJO3d+1znU59AoD
         m75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=c5fDiX3zbTamI1qqbp2re4XV73zDzkQMbszKWk9pl4w=;
        b=oyy5/8o+HRA1tPBfMroCeyhjlBdAre217VPGCxNH5/CI6kntsE5Q28YLjzoaJKK66K
         ag9yNQf2h+2Gye5icaSraEVDB5oAMrGAcH+6IT8s7A3OgyNnpVPSmGRBxT0+nIOFvG/b
         vnNPOqjSkBL6uIzaDWLiD1N1dqYjhaH2m9+YUEvww1JWht49thJh7GJ7zSLg1dUOmJ9r
         53Ball717bRVb/zGPPRLJGGCbWbcqhC51AfugZ0+jd+Xt9u+ZdFInChCIlGXm9ivEmGk
         WBIfUXOXLI++O+BiUEpBERaf2fn7Mvp+iFDPZuWOJvsaewpHGAkpYVeNeQzSY8sSrul8
         7nPw==
X-Gm-Message-State: APjAAAVCmMhOBhANwJr8619mODrE9TRP3/KNmBqm2k3aZDCOD2eaIrB+
        okpEM8tarreGIqqWKPqCEVDkpiC6/w0DLVfXDKo=
X-Google-Smtp-Source: APXvYqybASots/ejGJt6UT/gJMx8mmTVOiY1GKntItOZLnsGi7VmK7OSqTlT4NZgYz4ExVGajtRgwMYoWWpNmLaEl+M=
X-Received: by 2002:a17:906:9451:: with SMTP id z17mr14907293ejx.90.1568907383917;
 Thu, 19 Sep 2019 08:36:23 -0700 (PDT)
MIME-Version: 1.0
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 19 Sep 2019 18:36:12 +0300
Message-ID: <CA+h21hq1O=hKbcFkNVHEBd_tTPL3o00ZhAFq5JHvSJx=+RyfFw@mail.gmail.com>
Subject: Segregating L2 forwarding domains with ocelot
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex, Joergen, Allan,

Currently the ocelot driver rejects enslaving switch ports to more
than one bridge:

static int ocelot_port_bridge_join(struct ocelot_port *ocelot_port,
                   struct net_device *bridge)
{
    struct ocelot *ocelot = ocelot_port->ocelot;

    if (!ocelot->bridge_mask) {
        ocelot->hw_bridge_dev = bridge;
    } else {
        if (ocelot->hw_bridge_dev != bridge)
            /* This is adding the port to a second bridge, this is
             * unsupported */
            return -ENODEV;
    }

    ocelot->bridge_mask |= BIT(ocelot_port->chip_port);

    return 0;
}

I am wondering why the ocelot driver is writing the same
bridge_fwd_mask to all PGID_SRC[port] registers? Judging from the
reference manual description of PGID_SRC, the hardware should be able
of managing a forwarding matrix and not just a forwarding array?

Regards,
-Vladimir
