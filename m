Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 545A917FC46
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 14:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbgCJNHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 09:07:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43204 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730627AbgCJNHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 09:07:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GBctA9BFs2dRq2xvddol3MFuR1N7eZmY+sPWQvcnahc=; b=0khZeQx3s/YBvbOuW8cGZfzi6Z
        SG5J3e+1FwCDmds4rAtz0zetv2BzLPfRfQuPPz4lR8RaPxEBU63SAptDgFRhONAHTYFx77xfjTI7A
        cRow5FxCuZaYhiI5Rs81fj6Z5z6oi/wXU0/S6qjI/5ExLmnkLdqDmpRDBCHDuqSD0ZcCT9n8b/itq
        /PNz/XkL+o61y2W3Glk7iuq3uC0HADCPIqofZrogd1Ht0epzx8nKe+pwqky8e0THZglnpZnpeUGEb
        9L8JFGLGLeWEJOpzTyEQh2rSCn0Pd22MqhaX6ZfRxtGI8XbsANYqZUaKkg5AcJF1veL5xz/9zweJ7
        CrILZ/6w==;
Received: from [54.239.6.187] (helo=u3832b3a9db3152.ant.amazon.com)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBebw-0003Kx-04; Tue, 10 Mar 2020 13:07:52 +0000
Message-ID: <dbbd0ba6d602b5106b484f7d9df7126e40c9b5e0.camel@infradead.org>
Subject: Re: TCP receive failure
From:   David Woodhouse <dwmw2@infradead.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     netdev@vger.kernel.org, Martin Pohlack <mpohlack@amazon.de>
Date:   Tue, 10 Mar 2020 13:07:49 +0000
In-Reply-To: <20200310103928.GB18192@1wt.eu>
References: <3748be15d31f71c6534f344b0c78f48fc4e3db21.camel@infradead.org>
         <20200310103928.GB18192@1wt.eu>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-DEU0e8t6xOo4nhphpS7D"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-DEU0e8t6xOo4nhphpS7D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-03-10 at 11:39 +0100, Willy Tarreau wrote:
> Hi David,
>=20
> On Tue, Mar 10, 2020 at 09:40:04AM +0000, David Woodhouse wrote:
> > I'm chasing a problem which was reported to me as an OpenConnect packet
> > loss, with downloads stalling until curl times out and aborts.
> >=20
> > I can't see a transport problem though; I think I see TCP on the
> > receive side misbehaving. This is an Ubuntu 5.3.x client kernel
> > (5.3.0-40-generic #32~18.04.1-Ubuntu) which I think is 5.3.18?
> >=20
> > The test is just downloading a large file full of zeroes. The problem
> > starts with a bit of packet loss and a 40ms time warp:
>=20
> So just to clear up a few points, it seems that the trace was taken on
> the client, right ?

Yes. Sorry, meant to make that explicit.

I have a server-side capture too. The absolute TCP sequence numbers are
different, implying that there's some translation or load balancer or
some other evilness happening. But as far as I can tell there's only
the delta in the seq#s and it isn't actually perturbing the connection
in any other way.

The server itself (also Linux but 4.9 IIRC) genuinely is sending those
weird 'future' packets, interleaved with the catch-up packets as noted.

Which are probably what's causing nf_conntrack to get out of sync with
the receive window.

> (...)
> > 19:14:03.040870 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ac=
k 1735803185, win 24171, options [nop,nop,TS val 2290572281 ecr 653279937,n=
op,nop,sack 1 {1735831937:1735884649}], length 0
> >=20
> > Looks sane enough so far...
> >=20
> > 19:14:03.041903 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], se=
q 1735950539:1735951737, ack 366489597, win 235, options [nop,nop,TS val 65=
3279937 ecr 2290572254], length 1198: HTTP
> >=20
> > WTF? The server has never sent us anything past 1735884649 and now it's
> > suddenly sending 1735950539? But OK, despite some confusing future
> > packets which apparently get ignored (and make me wonder if I really
> > understand what's going on here), the client is making progress because
> > the server is *also* sending sensible packets, and the originally
> > dropped segments are being recovered...
> >=20
> > 19:14:03.068337 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], se=
q 1735803185:1735804383, ack 366489597, win 235, options [nop,nop,TS val 65=
3279944 ecr 2290572281], length 1198: HTTP
> > 19:14:03.068363 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ac=
k 1735804383, win 24171, options [nop,nop,TS val 2290572309 ecr 653279944,n=
op,nop,sack 1 {1735831937:1735884649}], length 0
>=20
> (...)
> > 19:14:03.211316 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ac=
k 1735884649, win 24171, options [nop,nop,TS val 2290572452 ecr 653279980],=
 length 0
> >=20
> > OK, now it's caught up. Client continues to ignore bogus future packets
> > from the server, and doesn't even SACK them.
>=20
> That's what caught my eyes as well.
>=20
> > 19:14:03.211629 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], se=
q 1735967311:1735968509, ack 366489597, win 235, options [nop,nop,TS val 65=
3279980 ecr 2290572422], length 1198: HTTP
>=20
> (... no ack here ...)
> > 19:14:03.251516 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], se=
q 1736028409:1736029607, ack 366489597, win 235, options [nop,nop,TS val 65=
3279989 ecr 2290572452], length 1198: HTTP
> >=20
> > Server finally comes to its senses and actually sends the packet that
> > the client wants. Repeatedly.
>=20
> This makes me think that there's very likely nf_conntrack on the client
> machine and the TCP packets you're seeing reach tcpdump but not the TCP
> layer. For some reason they're very likely considered out of window and
> are silently dropped. Since we don't have the SYN we don't know the
> window size, but we can try to guess. There was 82662 unacked bytes in
> flight at the peak when the server went crazy, for an apparent window of
> 24171, making me think the window scaling was at least 4, or that the
> server wrongly assumed so. But earlier when the client was sending SACKs
> I found bytes in flight as high as 137770 for an advertised window of
> 24567 (5.6 times more), thus the window scaling is at least 8. So this
> indicates that the 82kB above are well within the window and the client
> should ACK them. But maybe they were dropped as invalid at the conntrack
> layer for another obscure reason.

19:14:03.469417 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 17=
35884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653280=
045 ecr 2290572452], length 1198: HTTP
19:14:03.933488 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 17=
35884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653280=
161 ecr 2290572452], length 1198: HTTP
19:14:04.861503 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 17=
35884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653280=
393 ecr 2290572452], length 1198: HTTP
19:14:06.735809 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 17=
35884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653280=
858 ecr 2290572452], length 1198: HTTP
19:14:10.524440 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 17=
35884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653281=
788 ecr 2290572452], length 1198: HTTP
19:14:17.881996 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 17=
35884649:1735885847, ack 366489597, win 235, options [nop,nop,TS val 653283=
648 ecr 2290572452], length 1198: HTTP

 (...goes back to reporter to check logs ... )

Mar  9 20:14:03 kernel: [71401.451732] [UFW BLOCK] IN=3Dtun0 OUT=3D MAC=3D =
SRC=3D10.28.82.105 DST=3D192.168.0.195 LEN=3D1250 TOS=3D0x00 PREC=3D0x00 TT=
L=3D120 ID=3D48152 DF PROTO=3DTCP SPT=3D80 DPT=3D53754 WINDOW=3D235 RES=3D0=
x00 ACK URGP=3D0=20
Mar  9 20:14:03 kernel: [71401.452582] [UFW BLOCK] IN=3Dtun0 OUT=3D MAC=3D =
SRC=3D10.28.82.105 DST=3D192.168.0.195 LEN=3D1250 TOS=3D0x00 PREC=3D0x00 TT=
L=3D120 ID=3D48154 DF PROTO=3DTCP SPT=3D80 DPT=3D53754 WINDOW=3D235 RES=3D0=
x00 ACK URGP=3D0=20
Mar  9 20:14:03 kernel: [71401.479972] [UFW BLOCK] IN=3Dtun0 OUT=3D MAC=3D =
SRC=3D10.28.82.105 DST=3D192.168.0.195 LEN=3D1250 TOS=3D0x00 PREC=3D0x00 TT=
L=3D120 ID=3D48158 DF PROTO=3DTCP SPT=3D80 DPT=3D53754 WINDOW=3D235 RES=3D0=
x00 ACK URGP=3D0=20
Mar  9 20:14:03 kernel: [71401.480304] [UFW BLOCK] IN=3Dtun0 OUT=3D MAC=3D =
SRC=3D10.28.82.105 DST=3D192.168.0.195 LEN=3D1250 TOS=3D0x00 PREC=3D0x00 TT=
L=3D120 ID=3D48160 DF PROTO=3DTCP SPT=3D80 DPT=3D53754 WINDOW=3D235 RES=3D0=
x00 ACK URGP=3D0=20
Mar  9 20:14:18 kernel: [71416.575237] [UFW BLOCK] IN=3Dtun0 OUT=3D MAC=3D =
SRC=3D10.28.82.105 DST=3D192.168.0.195 LEN=3D52 TOS=3D0x00 PREC=3D0x00 TTL=
=3D120 ID=3D48252 DF PROTO=3DTCP SPT=3D80 DPT=3D53754 WINDOW=3D235 RES=3D0x=
00 ACK URGP=3D0=20
Mar  9 20:14:18 kernel: [71416.777021] [UFW BLOCK] IN=3Dtun0 OUT=3D MAC=3D =
SRC=3D10.28.82.105 DST=3D192.168.0.195 LEN=3D64 TOS=3D0x00 PREC=3D0x00 TTL=
=3D120 ID=3D48253 DF PROTO=3DTCP SPT=3D80 DPT=3D53754 WINDOW=3D235 RES=3D0x=
00 ACK URGP=3D0=20
Mar  9 20:14:18 kernel: [71417.019399] [UFW BLOCK] IN=3Dtun0 OUT=3D MAC=3D =
SRC=3D10.28.82.105 DST=3D192.168.0.195 LEN=3D64 TOS=3D0x00 PREC=3D0x00 TTL=
=3D120 ID=3D48254 DF PROTO=3DTCP SPT=3D80 DPT=3D53754 WINDOW=3D235 RES=3D0x=
00 ACK URGP=3D0=20
Mar  9 20:14:19 kernel: [71417.526725] [UFW BLOCK] IN=3Dtun0 OUT=3D MAC=3D =
SRC=3D10.28.82.105 DST=3D192.168.0.195 LEN=3D64 TOS=3D0x00 PREC=3D0x00 TTL=
=3D120 ID=3D48255 DF PROTO=3DTCP SPT=3D80 DPT=3D53754 WINDOW=3D235 RES=3D0x=
00 ACK URGP=3D0=20

Yeah, spot on. Thanks. Will stare accusingly at nf_conntrack, and
perhaps also at the server side which is sending the later sequence
numbers and presumably confusing it.


--=-DEU0e8t6xOo4nhphpS7D
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAw
MzEwMTMwNzQ5WjAvBgkqhkiG9w0BCQQxIgQgE1nGYuDLR4vPl+922Wki+6jODYta2KobyFDCAkHo
WFcwgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBACAxap6bqQOgVa0X7LuuOrFH+cCwP4nCXXz+hRw7uAbf+07rCKCvJdspGGxQHReV
ozZ2TYSUq8ZSzlD2erwW+dutFZkkDxsGF9kvCjMYfcwtEg9d7ofjsa728rrRP4Ty+kLO9lz1lpRr
tFVp1M2QXBwPNZqjmUebXXvsSlvrBHPmogqMwE70WZpNqtzfPc76P6R/vX+YvLryq8cEA37myJ5U
km6v19mXregdGSktRwHt9xpMeH4Fr4MegTOhwKz2SwIXeFyYEyvHu1racZfpSyPrb7ZVx+L7HtEK
T+FZxi3H8R8cpiUX8OH6TCOXzLtiaHipQOEVfKM7xuE6f5X++OoAAAAAAAA=


--=-DEU0e8t6xOo4nhphpS7D--

